class Generation < ApplicationRecord
  belongs_to :user

  # Status constants
  STATUSES = {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    failed: 'failed'
  }.freeze

  # Available styles
  STYLES = %w[natural artistic cartoon realistic].freeze

  # Available sizes with common aspect ratios
  SIZES = {
    'portrait' => '576x1024',   # 9:16 aspect ratio
    'landscape' => '1024x576',  # 16:9 aspect ratio
    'square_large' => '1024x1024',
    'square_medium' => '512x512'
  }.freeze

  # Validations
  validates :prompt, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :style, presence: true, inclusion: { in: STYLES }
  validates :size, presence: true, inclusion: { in: SIZES.values }
  validates :status, presence: true, inclusion: { in: STATUSES.values }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  # Callbacks
  before_validation :set_default_status, on: :create

  # Helper methods
  def size_format
    SIZES.key(size) || 'custom'
  end

  def dimensions
    return [nil, nil] unless size
    width, height = size.split('x').map(&:to_i)
    [width, height]
  end

  def width
    dimensions[0]
  end

  def height
    dimensions[1]
  end

  def filtered_metadata
    return {} unless metadata
    
    # List of fields to exclude
    excluded_fields = %w[
      rescale webhook model_id track_id clip_skip n_samples watermark
      scale_down file_prefix padding_down padding_right enhance_prompt
      guidance_scale safety_checker safety_checker_type instant_response
      id temp base64 opacity
    ]
    
    metadata.reject { |key, _| excluded_fields.include?(key) }
  end

  private

  def set_default_status
    self.status ||= STATUSES[:pending]
  end
end

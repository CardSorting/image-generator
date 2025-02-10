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

  # Available sizes
  SIZES = %w[256x256 512x512 1024x1024].freeze

  # Validations
  validates :prompt, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :style, presence: true, inclusion: { in: STYLES }
  validates :size, presence: true, inclusion: { in: SIZES }
  validates :status, presence: true, inclusion: { in: STATUSES.values }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  # Callbacks
  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= STATUSES[:pending]
  end
end

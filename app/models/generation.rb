class Generation < ApplicationRecord
  belongs_to :user
  
  STATUSES = {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }.freeze

  SIZES = {
    small: "256x256",
    medium: "512x512",
    large: "1024x1024"
  }.freeze

  STYLES = {
    natural: "natural",
    artistic: "artistic",
    cartoon: "cartoon",
    realistic: "realistic"
  }.freeze

  validates :prompt, presence: true, length: { minimum: 3, maximum: 1000 }
  validates :size, presence: true, inclusion: { in: SIZES.values }
  validates :style, presence: true, inclusion: { in: STYLES.keys.map(&:to_s) }
  validates :status, presence: true, inclusion: { in: STATUSES.values }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= STATUSES[:pending]
  end
end

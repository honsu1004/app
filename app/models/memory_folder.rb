class MemoryFolder < ApplicationRecord
  belongs_to :plan
  has_many :memories, dependent: :destroy
  has_many_attached :media, dependent: :purge_later

  delegate :user, to: :plan

  validates :name, presence: true

  def image_count
    memories.sum do |memory|
      memory.media.count { |attachment| attachment.content_type&.start_with?("image/") }
    end
  end

  def video_count
    memories.sum do |memory|
      memory.media.count { |attachment| attachment.content_type&.start_with?("video/") }
    end
  end
end

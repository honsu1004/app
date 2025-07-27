class MemoryFolder < ApplicationRecord
  belongs_to :plan
  has_many :memories, dependent: :destroy
  has_many_attached :media, dependent: :purge_later

  validates :name, presence: true
end

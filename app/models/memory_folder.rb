class MemoryFolder < ApplicationRecord
  belongs_to :plan
  has_many :memories, dependent: :destroy
  has_many_attached :media

  validates :name, presence: true
end

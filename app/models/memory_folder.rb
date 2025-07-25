class MemoryFolder < ApplicationRecord
  belongs_to :plan
  has_many :memories, dependent: :destroy

  validates :name, presence: true
end

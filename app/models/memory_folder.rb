class MemoryFolder < ApplicationRecord
  belongs_to :plan
  has_many :memories, dependent: :destroy

  validates :nema, presence: true
end

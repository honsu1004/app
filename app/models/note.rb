class Note < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :content, presence: true
end

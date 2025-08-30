class ChecklistItem < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  validates :name, presence: true
  validates :item_type, inclusion: { in: %w[shared personal] }
  validates :user_id, presence: true

  enum :item_type, { shared: 0, personal: 1 }
end

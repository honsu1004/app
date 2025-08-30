class UserChecklistItem < ApplicationRecord
  belongs_to :user
  belongs_to :checklist_item

  validates :user_id, uniqueness: { scope: :checklist_item_id }
end

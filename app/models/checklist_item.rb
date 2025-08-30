class ChecklistItem < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  has_many :user_checklist_items, dependent: :destroy
  has_many :checked_users, through: :user_checklist_items, source: :user

  validates :name, presence: true
  validates :item_type, inclusion: { in: %w[shared personal] }
  validates :user_id, presence: true

  enum :item_type, { shared: 0, personal: 1 }

  def checked_by?(user)
    user_checklist_items.find_by(user: user)&.is_checked || false
  end

  def toggle_check_for_user!(user)
    user_item = user_checklist_items.find_or_create_by(user: user)
    user_item.update!(is_checked: !user_item.is_checked)
  end
end

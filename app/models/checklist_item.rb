class ChecklistItem < ApplicationRecord
  belongs_to :plan
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :user_checklist_items, dependent: :destroy
  has_many :users, through: :user_checklist_items
  has_many :checked_users, through: :user_checklist_items, source: :user

  validates :name, presence: true
  validates :item_type, presence: true
  validates :is_shared, inclusion: { in: [true, false] }
  # 共有アイテムの場合のみ担当者を必須にする
  validates :assignee_id, presence: { message: '担当者を選択してください' }, if: :is_shared?

  enum :item_type, { shared: 0, personal: 1 }

  # プランメンバーに表示すべきアイテムのスコープを追加
  scope :visible_to_plan_member, ->(user, plan) {
    where(plan: plan).where(
      "item_type = ? OR (item_type = ? AND EXISTS (
        SELECT 1 FROM user_checklist_items uci 
        WHERE uci.checklist_item_id = checklist_items.id 
        AND uci.user_id = ?
      ))",
      item_types[:shared], item_types[:personal], user.id
    )
  }

  def checked_by?(user)
    user_checklist_items.find_by(user: user)&.is_checked || false
  end

  def assigned?
    assignee_id.present?
  end

  def toggle_check_for_user!(user)
    user_item = user_checklist_items.find_or_create_by(user: user)
    user_item.update!(is_checked: !user_item.is_checked)
  end

  def completed?
    completed == true
  end
end

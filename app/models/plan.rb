class Plan < ApplicationRecord
  def accessible_by?(user)
    user_id == user.id || members.exists?(user.id)
  end
  belongs_to :user
  has_many :plan_members, dependent: :destroy
  has_many :members, through: :plan_members, source: :user
  has_many :users, through: :plan_members
  has_many :plan_invitations
  has_many :schedule_items, dependent: :destroy
  has_many :memory_folders, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :checklist_items, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :title, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :end_date_after_start_date

  after_create :add_owner_as_member

  private

  def end_date_after_start_date
    if start_at && end_at && end_at < start_at
      errors.add(:end_at, "は開始日以降を指定してください")
    end
  end

  def add_owner_as_member
    plan_members.create!(user: user)
  end
end

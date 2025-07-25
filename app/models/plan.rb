class Plan < ApplicationRecord
  belongs_to :user
  has_many :plan_members, dependent: :destroy
  has_many :members, through: :plan_members, source: :user
  has_many :schedule_items
  has_many :memory_folders
  has_many :chat_messages
  has_many :checklist_items
  has_many :notes

  validates :title, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if start_at && end_at && end_at < start_at
      errors.add(:end_at, "は開始日以降を指定してください")
    end
  end
end

class Plan < ApplicationRecord
  belongs_to :user
  has_many :plan_members, dependent: :destroy
  has_many :members, through: :plan_members, source: :user
  has_many :schedule_items
  has_many :memory_folders
  has_one :chat_message
  has_one :checklist_item
  has_one :notes
  validates :title, presence: true
end

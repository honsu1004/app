class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
  has_many :plans, dependent: :destroy
  has_many :plan_members
  has_many :joined_plans, through: :plan_members, source: :plan
  has_many :chat_messages
  has_many :notes
  has_many :memories, dependent: :destroy
  has_many :memory_folders, through: :plans
  has_many :schedule_items
  has_many :checklist_items, through: :user_checklist_items
  has_many :user_checklist_items, dependent: :destroy
  has_many :checked_checklist_items, through: :user_checklist_items, source: :checklist_item
end

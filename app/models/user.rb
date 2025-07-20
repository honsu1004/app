class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, uniqueness: true
  has_many :plans
  has_many :plan_members
  has_many :joined_plans, through: :plan_members, source: :plan
  has_many :chat_messages
  has_many :notes
  has_many :memories
  has_many :memory_folders
  has_many :schedule_items
end

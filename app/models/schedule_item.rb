class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  # ★ここを追加！プランメンバーの管理
  has_many :plan_members, dependent: :destroy
  has_many :members, through: :plan_members, source: :user

  scope :ordered_by_day_and_time_ruby, -> {
    all.sort_by { |item| [item.day_number, item.start_time ? [item.start_time.hour, item.start_time.min] : [23, 59]] }
  }

  def formatted_time
    start_time&.strftime('%H:%M')
  end

  # participantsメソッドを追加（membersとプラン作成者を含める）
  def participants
    User.where(id: [user_id] + member_ids).distinct
  end

  validates :start_time, presence: true
  validates :location_name, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end

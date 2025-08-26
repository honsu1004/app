class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :start_time, presence: true

  def formatted_time_range
    return "" unless start_time.present?

    result = "🕒 #{start_time.strftime('%H:%M')}"
    result += " 〜 #{end_time.strftime('%H:%M')}" if end_time.present?
    result
  end
end

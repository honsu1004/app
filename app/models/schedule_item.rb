class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  scope :ordered_by_day_and_time_ruby, -> {
    all.sort_by { |item| [item.day_number, item.start_time ? [item.start_time.hour, item.start_time.min] : [23, 59]] }
  }

  def formatted_time
    start_time&.strftime('%H:%M')
  end

  validates :start_time, presence: true
  validates :location_name, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end

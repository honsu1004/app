class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  scope :ordered_by_day_and_time_only, -> {
    order(:day_number, Arel.sql("TIME(start_time)"))
  }

  validates :start_time, presence: true
  validates :location_name, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end

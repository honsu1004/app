class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  scope :ordered_by_time, -> {
    order(:day_number)
    .order(Arel.sql('CASE WHEN start_time IS NULL THEN 1 ELSE 0 END'))
    .order(:start_time)
  }

  validates :start_time, presence: true
  validates :location_name, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end

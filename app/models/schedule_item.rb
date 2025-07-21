class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end

class ScheduleItem < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  # positionによる並び替えを設定
  scope :ordered, -> { order(:day_number, :position, :start_time) }
  
  # 新規作成時にpositionを自動設定
  before_create :set_position

  validates :start_time, presence: true
  validates :location_name, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

  def formatted_time_range
    return "" unless start_time.present?

    result = "🕒 #{start_time.strftime('%H:%M')}"
    result += " 〜 #{end_time.strftime('%H:%M')}" if end_time.present?
    result
  end

  private
  
  def set_position
    return if position.present?
    
    max_position = ScheduleItem.where(
      plan_id: plan_id,
      day_number: day_number
    ).maximum(:position) || 0
    
    self.position = max_position + 1
  end
end

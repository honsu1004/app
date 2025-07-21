class AddStartTimeToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :start_time, :datetime
  end
end

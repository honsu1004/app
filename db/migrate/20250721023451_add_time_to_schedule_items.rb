class AddTimeToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :start_time, :time
    add_column :schedule_items, :end_time, :time
  end
end

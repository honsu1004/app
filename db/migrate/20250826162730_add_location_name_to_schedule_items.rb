class AddLocationNameToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :location_name, :string
  end
end

class AddUrlToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :url, :string
  end
end

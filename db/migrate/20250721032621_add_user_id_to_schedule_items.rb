class AddUserIdToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :schedule_items, :user, null: false, foreign_key: true
  end
end

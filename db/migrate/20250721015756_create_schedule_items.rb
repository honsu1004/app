class CreateScheduleItems < ActiveRecord::Migration[8.0]
  def change
    create_table :schedule_items do |t|
      t.integer :plan_id
      t.integer :day_number
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :updated_user_id

      t.timestamps
    end
  end
end

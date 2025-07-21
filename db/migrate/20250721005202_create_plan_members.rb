class CreatePlanMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_members do |t|
      t.integer :user_id
      t.integer :plan_id
      t.datetime :joined_at

      t.timestamps
    end
  end
end

class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.integer :plan_id
      t.integer :user_id
      t.text :content
      t.integer :updated_user_id

      t.timestamps
    end
  end
end

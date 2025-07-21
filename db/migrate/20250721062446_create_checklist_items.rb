class CreateChecklistItems < ActiveRecord::Migration[8.0]
  def change
    create_table :checklist_items do |t|
      t.integer :plan_id
      t.boolean :is_checked

      t.timestamps
    end
  end
end

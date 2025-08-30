class CreateUserChecklistItems < ActiveRecord::Migration[8.0]
  def change
    create_table :user_checklist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :checklist_item, null: false, foreign_key: true
      t.boolean :is_checked

      t.timestamps
    end

    add_index :user_checklist_items, [:user_id, :checklist_item_id], unique: true
  end
end

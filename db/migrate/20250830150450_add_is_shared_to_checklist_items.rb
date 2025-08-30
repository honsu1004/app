class AddIsSharedToChecklistItems < ActiveRecord::Migration[8.0]
  def change
    add_column :checklist_items, :is_shared, :boolean, default: true, null: false
  end
end

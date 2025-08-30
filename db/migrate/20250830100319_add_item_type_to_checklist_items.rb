class AddItemTypeToChecklistItems < ActiveRecord::Migration[8.0]
  def change
    add_column :checklist_items, :item_type, :integer, default: 0

    ChecklistItem.update_all(item_type: 0)
  end
end

class RemoveIsCheckedFromChecklistItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :checklist_items, :is_checked, :boolean
  end
end

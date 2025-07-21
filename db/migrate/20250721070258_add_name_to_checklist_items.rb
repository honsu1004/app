class AddNameToChecklistItems < ActiveRecord::Migration[8.0]
  def change
    add_column :checklist_items, :name, :string
  end
end

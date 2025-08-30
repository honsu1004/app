class RemoveUserIdFromChecklistItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :checklist_items, :user_id, :integer
  end
end

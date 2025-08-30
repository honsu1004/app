class AddAssigneeToChecklistItems < ActiveRecord::Migration[7.0]
  def change
    # integer → bigint に変更
    add_column :checklist_items, :assignee_id, :bigint
    add_index :checklist_items, :assignee_id
    add_foreign_key :checklist_items, :users, column: :assignee_id
  end
end

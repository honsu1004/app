class RemoveUserIdFromChecklistItems < ActiveRecord::Migration[8.0]
  def change
    # カラムが存在する場合のみ削除
    if column_exists?(:checklist_items, :user_id)
      remove_column :checklist_items, :user_id, :integer
    end
  end
end

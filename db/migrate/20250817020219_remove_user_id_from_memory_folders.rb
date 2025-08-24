class RemoveUserIdFromMemoryFolders < ActiveRecord::Migration[8.0]
  def change
    remove_column :memory_folders, :user_id, :bigint
  end
end

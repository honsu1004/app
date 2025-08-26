class RenameAddressToMemoInScheduleItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :schedule_items, :address, :memo
  end
end

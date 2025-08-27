class AddPositionToScheduleItems < ActiveRecord::Migration[7.0]
  def change
    add_column :schedule_items, :position, :integer
    
    # 既存データにpositionを設定
    reversible do |dir|
      dir.up do
        ScheduleItem.reset_column_information
        ScheduleItem.find_each do |item|
          # 同じ日の中での順番を設定
          position = ScheduleItem.where(
            plan_id: item.plan_id,
            day_number: item.day_number
          ).where('id <= ?', item.id).count
          
          item.update_column(:position, position)
        end
      end
    end
    
    add_index :schedule_items, [:plan_id, :day_number, :position]
  end
end

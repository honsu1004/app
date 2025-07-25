class CreateMemoryFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :memory_folders do |t|
      t.references :plan, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end

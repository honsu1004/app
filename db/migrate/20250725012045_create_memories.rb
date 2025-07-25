class CreateMemories < ActiveRecord::Migration[8.0]
  def change
    create_table :memories do |t|
      t.references :memory_folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :url
      t.text :caption

      t.timestamps
    end
  end
end

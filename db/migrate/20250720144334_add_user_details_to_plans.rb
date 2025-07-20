class AddUserDetailsToPlans < ActiveRecord::Migration[7.2]
  def change
    add_column :plans, :user_id, :integer
    add_column :plans, :start_at, :datetime
    add_column :plans, :end_at, :datetime
    add_column :plans, :title, :string
  end
end

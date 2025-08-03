class CreatePlanInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_invitations do |t|
      t.references :plan, null: false, foreign_key: true
      t.string :email
      t.string :token
      t.datetime :accepted_at

      t.timestamps
    end
  end
end

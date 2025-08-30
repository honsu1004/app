class PlanMember < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  validates :plan_id, uniqueness: { scope: :user_id }
end

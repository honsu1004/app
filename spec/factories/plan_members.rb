FactoryBot.define do
  factory :plan_member do
    association :plan
    association :user
  end
end

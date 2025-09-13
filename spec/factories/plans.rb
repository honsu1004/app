FactoryBot.define do
  factory :plan do
    sequence(:title) { |n| "テストプラン#{n}" }
    start_at { Date.current }
    end_at { Date.current + 7.days }
    association :user
  end
end

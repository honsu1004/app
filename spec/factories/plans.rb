FactoryBot.define do
  factory :plan do
    sequence(:title) { |n| "テストプラン#{n}" }
    start_at { Date.current }
    end_at { Date.current + 7.days }  # start_atより後の日付
    association :user
  end
end

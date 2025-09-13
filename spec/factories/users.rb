FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:name) { |n| "テストユーザー#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end

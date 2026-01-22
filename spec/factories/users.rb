FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "123456" }
    role { "child" }
    association :account
  end
end

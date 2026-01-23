FactoryBot.define do
  factory :activity_assignment do
    activity

    user { association :user, account: activity.account }

    position { 1 }
  end
end

FactoryBot.define do
  factory :activity do
    association :account

    user { association :user, account: account }

    name { "Mop the floor" }
    activity_type { :chore }
    status { :draft }
    period { :week }
    frequency { 1 }
    times_per_period { 7 }
  end
end

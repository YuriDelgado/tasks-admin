FactoryBot.define do
  factory :activity do
    association :user
    name { "Test Activity" }
    activity_type { :chore }
    status { :draft }
    period { :day }
    frequency { 1 }
    times_per_period { 1 }
  end
end

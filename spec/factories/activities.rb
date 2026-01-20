FactoryBot.define do
  factory :activity do
    association :user
    name { "Mop the floor" }
    activity_type { :chore }
    status { :draft }
    period { :week }
    frequency { 1 }
    times_per_period { 7 }
  end
end

FactoryBot.define do
  factory :activity_assignment do
    association :activity
    association :user
    sequence(:position)
  end
end

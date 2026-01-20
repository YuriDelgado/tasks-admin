FactoryBot.define do
  factory :task do
    association :activity
    status { "pending" }
    assigned_to { association :user }
    due_on { Time.current }
  end
end

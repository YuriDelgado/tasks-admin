FactoryBot.define do
  factory :task do
    association :activity
    status { "pending" }
    assigned_to { activity.user }
    due_on { Date.today }
  end
end

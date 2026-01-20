FactoryBot.define do
  factory :task do
    association :activity
    status { "pending" }
    assigned_to { association :user }
    due_on { Date.today + 1.day }
  end
end

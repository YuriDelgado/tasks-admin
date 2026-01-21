FactoryBot.define do
  factory :task_override do
    association :task
    assigned_to { association :user }
    overridden_by { association :user }
    due_on { Date.today + 7.days }
    reason { "Need more time" }
  end
end

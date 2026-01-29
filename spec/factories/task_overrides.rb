FactoryBot.define do
  factory :task_override do
    task

    overridden_by do
      create(
        :user,
        account: task.activity.account,
        role: :parent
      )
    end

    assigned_to do
      create(
        :user,
        account: task.activity.account
      )
    end

    due_on { Date.today }
    reason { "Manual adjustment" }
  end
end

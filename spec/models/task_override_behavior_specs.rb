require "rails_helper"

describe Task do
  let(:original_user) { create(:user) }
  let(:new_user)      { create(:user) }

  let(:task) do
    create(:task, assigned_to: original_user, due_on: Date.today)
  end

  it "returns overridden assignee when override exists" do
    create(:task_override, task:, assigned_to: new_user)

    expect(task.effective_assigned_to).to eq(new_user)
  end

  it "returns overridden due date when override exists" do
    new_date = Date.today + 2
    create(:task_override, task:, due_on: new_date)

    expect(task.effective_due_on).to eq(new_date)
  end
end

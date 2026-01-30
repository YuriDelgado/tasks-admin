require "rails_helper"

describe Task, type: :model do
  let(:account) { create(:account) }
  let(:activity) { create(:activity, account: account, status: :active) }

  let(:original_user) { create(:user, account: account) }
  let(:override_user) { create(:user, account: account) }

  let(:task) do
    create(
      :task,
      activity: activity,
      assigned_to: original_user,
      due_on: Date.today
    )
  end

  context "without override" do
    it "returns assigned_to from task" do
      expect(task.effective_assigned_to).to eq(original_user)
    end

    it "returns due_on from task" do
      expect(task.effective_due_on).to eq(Date.today)
    end
  end

  context "with override" do
    before do
      create(
        :task_override,
        task: task,
        assigned_to: override_user,
        due_on: Date.tomorrow
      )
    end

    it "returns override assigned_to" do
      expect(task.effective_assigned_to).to eq(override_user)
    end

    it "returns override due_on" do
      expect(task.effective_due_on).to eq(Date.tomorrow)
    end
  end

  context "with partial override" do
    before do
      create(
        :task_override,
        task: task,
        assigned_to: override_user
      )
    end

    it "uses overridden assigned_to" do
      expect(task.effective_assigned_to).to eq(override_user)
    end

    it "falls back to task due_on" do
      expect(task.effective_due_on).to eq(Date.today)
    end
  end

  context "when override is removed" do
    let!(:override) do
      create(:task_override, task: task, assigned_to: override_user)
    end

    before {
      override.destroy
      task.reload
    }

    it "falls back to rotation" do
      expect(task.effective_assigned_to).to eq(original_user)
    end
  end
end

require 'rails_helper'
RSpec.describe Tasks::Override do
  let(:activity) { create(:activity, status: :active) }
  let(:task) { create(:task, activity: activity) }
  let(:parent) { create(:user, role: :parent) }
  let(:child) { create(:user, role: :child) }

  context "authorization" do
    it "blocks non-privileged users" do
      expect {
        described_class.call(task: task, actor: child, due_on: Date.tomorrow)
      }.to raise_error(UnauthorizedError)
    end
  end

  context "override creation" do
    it "creates an override" do
      override = described_class.call(
        task: task,
        actor: parent,
        due_on: Date.tomorrow,
        reason: "Sick"
      )

      expect(override).to be_persisted
      expect(task.task_override.due_on).to eq(Date.tomorrow)
    end
  end

  context "override update" do
    it "updates existing override" do
      existing = create(:task_override, task: task, due_on: Date.today)

      described_class.call(
        task: task,
        actor: parent,
        due_on: Date.tomorrow,
        reason: "no reason"
      )

      expect(existing.reload.due_on).to eq(Date.tomorrow)
    end
  end
end

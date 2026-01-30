require "rails_helper"

RSpec.describe Tasks::Override do
  subject(:call_service) do
    described_class.call(
      task: task,
      actor: actor,
      assigned_to: assigned_to,
      due_on: due_on,
      reason: reason
    )
  end

  let(:account) { create(:account) }
  let(:activity) { create(:activity, account: account, status: :active) }
  let(:task) { create(:task, activity: activity) }

  let(:assigned_to) { nil }
  let(:due_on) { nil }
  let(:reason) { "Manual override" }

    context "when authorized and no override exists" do
    let(:actor) { create(:user, account: account, role: :parent) }
    let(:assigned_to) { create(:user, account: account) }

    it "creates a task override" do
      expect { call_service }.to change(TaskOverride, :count).by(1)
    end

    it "sets assigned_to" do
      override = call_service
      expect(override.assigned_to).to eq(assigned_to)
    end
  end

  context "when override already exists" do
    let(:actor) { create(:user, account: account, role: :parent) }
    let(:assigned_to) { create(:user, account: account) }

    let!(:existing_override) do
      create(
        :task_override,
        task: task,
        overridden_by: actor,
        due_on: Date.today
      )
    end

    it "does not create a new override" do
      expect { call_service }.not_to change(TaskOverride, :count)
    end

    it "updates the override" do
      override = call_service
      expect(override.assigned_to).to eq(assigned_to)
    end
  end

  context "when actor is not authorized" do
    let(:actor) { create(:user, account: account, role: :child) }

    it "raises authorization error" do
      expect {
        call_service
      }.to raise_error(UnauthorizedError)
    end
  end

  context "when actor is from another account" do
    let(:actor) { create(:user, role: :parent) }

    it "raises authorization error" do
      expect {
        call_service
      }.to raise_error(UnauthorizedError)
    end
  end

  context "when no override attributes provided" do
    let(:actor) { create(:user, account: account, role: :parent) }

    it "raises argument error" do
      expect {
        call_service
      }.to raise_error(ArgumentError, /Nothing to override/)
    end
  end
end

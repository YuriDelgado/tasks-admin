require "rails_helper"
describe Activity, type: :model do
  describe "#generate_tasks!" do
    let(:activity) { create(:activity, period: :week, times_per_period: 7, status: "active") }

    let!(:a1) { create(:activity_assignment, activity:, position: 1) }
    let!(:a2) { create(:activity_assignment, activity:, position: 2) }

    let(:from) { Date.new(2026, 1, 1) }
    let(:to)   { Date.new(2026, 1, 7) }

    it "creates the correct number of tasks" do
      expect {
        activity.generate_tasks!(from:, to:)
      }.to change(Task, :count).by(7)
    end

    it "assigns tasks using rotation" do
      activity.generate_tasks!(from:, to:)

      assignees = activity.tasks.order(:due_on).map(&:assigned_to)

      expect(assignees).to eq([
        a1.user, a2.user,
        a1.user, a2.user,
        a1.user, a2.user,
        a1.user
      ])
    end

    it "sets due_on correctly" do
      activity.generate_tasks!(from:, to:)

      due_dates = activity.tasks.order(:due_on).map(&:due_on)

      expect(due_dates).to eq((from..to).to_a)
    end

    it "does not generate duplicate tasks" do
      activity.generate_tasks!(from:, to:)

      expect {
        activity.generate_tasks!(from:, to:)
      }.not_to change(Task, :count)
    end
  end
end

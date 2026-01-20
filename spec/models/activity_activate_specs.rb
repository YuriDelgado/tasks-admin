RSpec.describe Activity, type: :model do
  let(:activity) { create(:activity) }
  let(:user) { create(:user) }

  context "when valid" do
    before do
      create(:activity_assignment, activity:, user:, position: 1)
    end

    it "generates tasks and activates the activity" do
      expect {
        activity.activate!
      }.to change(Task, :count).by(activity.times_per_period)

      expect(activity.reload).to be_active
    end
  end

  context "when already active" do
    before do
      activity.update!(status: :active)
    end

    it "raises an error" do
      expect {
        activity.activate!
      }.to raise_error("Activity already active")
    end
  end

  context "when no assignees exist" do
    it "raises an error" do
      expect {
        activity.activate!
      }.to raise_error("No assignees defined")
    end
  end
end

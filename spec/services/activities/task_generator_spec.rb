require 'rails_helper'
RSpec.describe Activities::TaskGenerator do
  let(:user) { create(:user, role: :parent) }
  let(:activity) { create(:activity, user: user, account: user.account) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    create(:activity_assignment, activity:, user: user1, position: 1)
    create(:activity_assignment, activity:, user: user2, position: 2)
  end

  it "creates tasks based on rotation" do
    expect {
      described_class.new(activity).generate!
    }.to change(Task, :count).by(7)

    tasks = activity.tasks.order(:due_on)

    expect(tasks.map(&:assigned_to)).to eq([
      user1, user2, user1, user2, user1, user2, user1
    ])
  end

  it "raises an error if no assignees exist" do
    expect {
      activity.assignees.clear
      described_class.new(activity).generate!
    }.to raise_error("No assignees defined")
  end
end

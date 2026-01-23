require 'rails_helper'
describe Activity, type: :model do
  context "activity rotation" do
    let(:user) { create(:user, role: "parent") }
    let(:activity) { create(:activity, user: user) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      create(:activity_assignment, activity:, user: user1, position: 1)
      create(:activity_assignment, activity:, user: user2, position: 2)
    end

    it "rotates assignees correctly" do
      expect(activity.assignee_for(0)).to eq(user1)
      expect(activity.assignee_for(1)).to eq(user2)
      expect(activity.assignee_for(2)).to eq(user1)
      expect(activity.assignee_for(3)).to eq(user2)
    end
  end

  context "#next_assignee" do
    let(:activity) { create(:activity, status: :active) }

    let!(:a1) { create(:activity_assignment, activity:, position: 1) }
    let!(:a2) { create(:activity_assignment, activity:, position: 2) }
    let!(:a3) { create(:activity_assignment, activity:, position: 3) }

    it "returns the first assignee when no tasks exist" do
      expect(activity.next_assignee).to eq(a1.user)
    end

    it "rotates to the next assignee" do
      create(:task, activity:, assigned_to: a1.user)

      expect(activity.next_assignee).to eq(a2.user)
    end

    it "wraps around to the first assignee" do
      create(:task, activity:, assigned_to: a3.user)

      expect(activity.next_assignee).to eq(a1.user)
    end

    it "ignores tasks assigned to users not in rotation" do
      outsider = create(:user, account: activity.account)

      create(:task, activity:, assigned_to: outsider)

      expect(activity.next_assignee).to eq(a1.user)
    end
  end
end

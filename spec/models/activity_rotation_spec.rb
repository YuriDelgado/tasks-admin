require 'rails_helper'
describe Activity, type: :model do
  let(:activity) { create(:activity) }
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

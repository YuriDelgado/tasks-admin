require 'rails_helper'

describe ActivityAssignment, type: :model do
  subject { build(:activity_assignment) }
  it { should belong_to(:activity) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:position) }

  it "keeps user and activity in the same account" do
    assignment = create(:activity_assignment)

    expect(assignment.user.account_id)
      .to eq(assignment.activity.account_id)
  end
end

require 'rails_helper'

describe ActivityAssignment, type: :model do
  subject { build(:activity_assignment) }
  it { should belong_to(:activity) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:position) }
end

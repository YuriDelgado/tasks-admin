require 'rails_helper'
RSpec.describe Activity, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should have_many(:activity_assignments).dependent(:destroy) }
  it { should have_many(:assignees).through(:activity_assignments) }
end

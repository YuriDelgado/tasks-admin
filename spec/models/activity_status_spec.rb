require 'rails_helper'
RSpec.describe Activity, type: :model do
  let(:activity) { create(:activity) }

  it "allows draft → active" do
    expect {
      activity.active!
    }.not_to raise_error
  end

  it "allows active → archived" do
    activity.active!

    expect {
      activity.archive!
    }.not_to raise_error
  end

  it "prevents active → draft" do
    activity.active!

    expect {
      activity.draft!
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "prevents archived → active" do
    activity.active!
    activity.archive!

    expect {
      activity.active!
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "prevents draft → archived" do
    expect {
      activity.archive!
    }.to raise_error(RuntimeError, "Only active activities can be archived")
  end
end

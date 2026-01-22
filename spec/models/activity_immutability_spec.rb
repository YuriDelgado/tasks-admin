require 'rails_helper'

describe Activity, type: :model do
  let(:activity) { create(:activity, status: "active") }

  it "prevents changing period" do
    expect {
      activity.update!(period: "month")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "prevents changing frequency" do
    expect {
      activity.update!(frequency: 10)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end

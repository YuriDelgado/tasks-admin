require 'rails_helper'

describe TaskOverride do
  it "is invalid without changes" do
    override = build(:task_override, assigned_to: nil, due_on: nil)
    expect(override).not_to be_valid
  end
end

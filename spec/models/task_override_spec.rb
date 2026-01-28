require 'rails_helper'

describe TaskOverride, type: :model do
  subject { build(:task_override) }

  it { should belong_to(:task) }
  it { should belong_to(:assigned_to).class_name("User").optional }
  it { should belong_to(:overridden_by).class_name("User") }

  it { should validate_presence_of(:reason) }

  it "requires at least one override field" do
    override = build(:task_override, assigned_to: nil, due_on: nil)
    expect(override).not_to be_valid
    expect(override.errors[:base]).to include("Must override assigned_to or due_on")
  end
end

require "rails_helper"

describe TaskOverridePolicy do
  let(:account) { create(:account) }
  let(:task) { create(:task, activity: create(:activity, account:)) }

  let(:child)  { create(:user, role: :child, account:) }
  let(:parent) { create(:user, role: :parent, account:) }

  it "denies child" do
    expect(described_class.new(child, task).allow?).to be false
  end

  it "allows parent" do
    expect(described_class.new(parent, task).allow?).to be true
  end
end

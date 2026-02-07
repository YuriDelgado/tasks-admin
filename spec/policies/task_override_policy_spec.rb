require "rails_helper"

describe TaskOverridePolicy do
  let(:account) { create(:account) }
  let(:activity) { create(:activity, account:) }
  let(:task) { create(:task, activity: activity) }
  let(:override) { build(:task_override, task: task) }

  context "as child" do
    let(:child)  { create(:user, role: :child, account:) }

    it "denies child" do
      expect(described_class.new(child, task).allow?).to be false
    end
  end

  context "as parent" do
    let(:parent) { create(:user, role: :parent, account:) }

    it "allows parent" do
      expect(described_class.new(parent, task).allow?).to be true
    end
  end

  context "as admin" do
    let(:admin) { create(:user, role: :admin, account:) }

    it "allows admin" do
      expect(described_class.new(admin, task).allow?).to be true
    end
  end

  context "different account" do
    let(:user) do
      create(:user, role: :parent) # different account
    end

    it "denies override" do
      expect(described_class.new(user, task).allow?).to be false
    end
  end

  context "without overridden_by" do
    let(:user) { nil }

    it "denies override" do
      expect(described_class.new(user, task).allow?).to be false
    end
  end
end

require "rails_helper"

describe ActivityOverridePolicy do
  let(:account)  { create(:account) }
  let(:activity) { create(:activity, account: account) }
  let(:override) { build(:activity_override, activity: activity) }

  subject { described_class.new(user, override) }

  context "admin" do
    let(:user) { create(:user, :admin, account: account) }
    it { expect(subject.create?).to be true }
  end

  context "parent" do
    let(:user) { create(:user, :parent, account: account) }
    it { expect(subject.create?).to be true }
  end

  context "child" do
    let(:user) { create(:user, :child, account: account) }
    it { expect(subject.create?).to be false }
  end

  context "cross-account user" do
    let(:user) { create(:user) }
    it { expect(subject.create?).to be false }
  end
end

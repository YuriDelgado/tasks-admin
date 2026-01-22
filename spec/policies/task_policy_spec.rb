require 'rails_helper'
describe TaskPolicy do
  let(:account) { create(:account) }
  let(:parent)  { create(:user, role: "parent", account: account) }
  let(:child)   { create(:user, role: "child", account: account) }
  let(:task)    { create(:task, assigned_to: child, activity: create(:activity, account: account)) }

  subject { described_class }

  it "allows child to complete own task" do
    expect(subject.new(child, task).complete?).to be true
  end

  it "prevents child from approving task" do
    expect(subject.new(child, task).approve?).to be false
  end

  it "allows parent to approve completed task" do
    task.update!(status: "completed")
    expect(subject.new(parent, task).approve?).to be true
  end
end

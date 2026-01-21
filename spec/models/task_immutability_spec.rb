require 'rails_helper'
RSpec.describe Task, type: :model do
  let(:activity) { create(:activity, status: :active) }
  let(:task) { create(:task, activity: activity) }

  it "prevents changing due_on" do
    expect {
      task.update!(due_on: 1.days.from_now)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "prevents reassignment" do
    expect {
      task.update!(assigned_to: create(:user))
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "allows completing the task" do
    expect {
      task.update!(completed_at: Time.current)
    }.not_to raise_error
  end

  it "prevents destroying the task" do
    expect(task.destroy).to be_falsey
    expect(task.errors[:base]).to include("tasks cannot be removed once the activity is active")
  end
end

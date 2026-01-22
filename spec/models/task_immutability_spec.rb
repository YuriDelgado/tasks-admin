require 'rails_helper'
describe Task, type: :model do
  let(:activity) { create(:activity, status: :active) }
  let(:task) { create(:task, activity: activity) }

  it "prevents changing due_on" do
    expect {
      task.update!(due_on: 1.day.from_now)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "prevents reassignment" do
    expect {
      task.update!(assigned_to: create(:user))
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "allows completing the task" do
    expect {
      task.completed!
    }.not_to raise_error
  end

  it "prevents destroying the task" do
    expect(task.destroy).to be_falsey
    expect(task.errors[:base]).to include("tasks cannot be removed once the activity is active")
  end
end

require 'rails_helper'

describe Task, type: :model do
  describe "#effective_assigned_to" do
    let(:task) { create(:task) }
    let(:other_user) { create(:user) }
    it "returns override when present" do
      create(:task_override, task: task, assigned_to: other_user)
      expect(task.effective_assigned_to).to eq(other_user)
    end
  end
end

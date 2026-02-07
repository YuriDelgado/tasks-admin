require 'rails_helper'

describe ActivityOverride, type: :model do
  it { should belong_to(:activity) }
  it { should belong_to(:assigned_to).class_name("User") }
  it { should belong_to(:created_by).class_name("User") }
  it { should have_many(:task_overrides).dependent(:destroy) }

  it "is invalid when date_to is before date_from" do
    override = build(
      :activity_override,
      date_from: Date.today,
      date_to: Date.yesterday
    )

    override.valid?
    expect(override.errors[:date_to]).to be_present
  end

  it "prevents cross-account overrides" do
    account_a = create(:account)
    account_b = create(:account)

    activity = create(:activity, account: account_a)
    created_by = create(:user, account: account_a)
    assigned_to = create(:user, account: account_b)

    override = build(
      :activity_override,
      activity: activity,
      created_by: created_by,
      assigned_to: assigned_to
    )

    expect(override).not_to be_valid
  end

  it "prevents overlapping overrides for the same activity" do
    activity = create(:activity)

    create(
      :activity_override,
      activity: activity,
      date_from: Date.today,
      date_to: Date.today + 5.days
    )

    overlapping = build(
      :activity_override,
      activity: activity,
      date_from: Date.today + 2.days,
      date_to: Date.today + 7.days
    )

    expect(overlapping).not_to be_valid
    expect(overlapping.errors[:base])
      .to include("Overlapping override exists")
  end

  describe "apply!" do
    it "creates task overrides for tasks in range" do
      activity = create(:activity)
      task1 = create(:task, activity: activity, due_on: Date.today)
      task2 = create(:task, activity: activity, due_on: Date.today + 10.days)

      override = create(:activity_override,
        activity: activity,
        date_from: Date.today,
        date_to: Date.today + 5.days
      )

      expect(task1.reload.task_override).to be_present
      expect(task2.reload.task_override).to be_nil
    end
  end

  describe "rollback!" do
    it "removes task overrides when activity override is destroyed" do
      activity = create(:activity)
      task = create(:task, activity: activity, due_on: Date.today)

      override = create(:activity_override, activity: activity)

      expect(task.reload.task_override).to be_present

      override.destroy

      expect(task.reload.task_override).to be_nil
    end
  end

  it "does not fail if no tasks exist yet" do
    activity = create(:activity)

    expect {
      create(:activity_override, activity: activity)
    }.not_to raise_error
  end
end

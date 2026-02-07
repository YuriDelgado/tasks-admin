class ActivityOverride < ApplicationRecord
  belongs_to :activity
  belongs_to :assigned_to, class_name: "User"
  belongs_to :created_by, class_name: "User"

  has_many :task_overrides, dependent: :destroy

  validates :date_from, :date_to, presence: true
  validate  :valid_date_range
  validate  :same_account
  validate  :no_overlapping_ranges

  after_commit :apply!, on: [ :create, :update ]
  after_destroy :rollback!

  def account_id
    activity.account_id
  end

  private

  def valid_date_range
    return if date_from.blank? || date_to.blank?
    return if date_from < date_to

    errors.add(:date_to, "must be on or after start date")
  end

  def same_account
    return if activity.blank?
    return if created_by.blank?

    users = [ assigned_to, created_by ]
    users << activity.user if assigned_to.present?

    return if users.map(&:account_id).uniq.one?

    errors.add(:base, "Users must belong to same account")
  end

  def no_overlapping_ranges
    overlap = ActivityOverride
      .where(activity_id: activity_id)
      .where.not(id: id)
      .where("date_from <= ? AND date_to >= ?", date_to, date_from)

    errors.add(:base, "Overlapping override exists") if overlap.exists?
  end

  def apply!
    tasks_in_range.find_each do |task|
      TaskOverride.upsert_for!(
        task: task,
        assigned_to: assigned_to,
        created_by: created_by,
        reason: reason,
        activity_override: self
      )
    end
  end

  def tasks_in_range
    activity.tasks.where(due_on: date_from..date_to)
  end

  def rollback!
    TaskOverride
      .joins(:task)
      .where(tasks: { activity_id: activity_id })
      .where(due_on: date_from..date_to)
      .destroy_all
  end
end

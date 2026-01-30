class TaskOverride < ApplicationRecord
  belongs_to :task, required: true
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :overridden_by, class_name: "User", required: true

  validates :reason, presence: true
  validate :at_least_one_override_present
  validate :authorized_override
  validates :task_id, uniqueness: true

  private

  def at_least_one_override_present
    if assigned_to.nil? && due_on.nil?
      errors.add(:base, "Must override assigned_to or due_on")
    end
  end

  def authorized_override
    return if task.nil? || overridden_by.nil?

    policy = TaskOverridePolicy.new(overridden_by, task)

    unless policy.allow?
      errors.add(:base, "Not authorized to override this task")
    end
  end
end

class TaskOverride < ApplicationRecord
  belongs_to :task
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :overridden_by, class_name: "User"

  validates :reason, presence: true
  validate :at_least_one_override_present

  def at_least_one_override_present
    if assigned_to.nil? && due_on.nil?
      errors.add(:base, "Must override assigned_to or due_on")
    end
  end
end

class TaskOverride < ApplicationRecord
  belongs_to :task
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :overridden_by, class_name: "User"

  validate :at_least_one_override

  def at_least_one_override
    if assigned_to_id.nil? && due_on.nil?
      errors.add(:base, "Override must change something")
    end
  end
end

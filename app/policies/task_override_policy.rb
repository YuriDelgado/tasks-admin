class TaskOverridePolicy < ApplicationPolicy
  def allow?
    same_account? &&
      user_manager? &&
      !record.approved?
  end
end

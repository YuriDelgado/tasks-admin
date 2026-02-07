class ActivityPolicy < ApplicationPolicy
  def create?
    user_manager?
  end

  def update?
    same_account? && user_manager?
  end

  def activate?
    same_account? && user_manager?
  end

  def archive?
    same_account? && user_manager?
  end

  def show?
    same_account?
  end
end

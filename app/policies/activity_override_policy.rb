class ActivityOverridePolicy < ApplicationPolicy
  def create?
    same_account? && user_manager?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end

class ActivityPolicy < ApplicationPolicy
  def create?
    admin? || parent?
  end

  def update?
    same_account? && (admin? || parent?)
  end

  def activate?
    same_account? && (admin? || parent?)
  end

  def archive?
    same_account? && (admin? || parent?)
  end

  def show?
    same_account?
  end
end

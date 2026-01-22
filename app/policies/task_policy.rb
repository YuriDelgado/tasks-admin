class TaskPolicy < ApplicationPolicy
  def show?
    same_account?
  end

  def complete?
    child? &&
      same_account? &&
      record.pending? &&
      record.assigned_to_id == user.id
  end

  def approve?
    parent? &&
      same_account? &&
      record.completed?
  end

  def reject?
    approve?
  end

  def override?
    parent? && same_account?
  end

  def destroy?
    false # tasks are immutable once created
  end

  private

    def same_account?
      record.activity.account_id == user.account_id
    end
end

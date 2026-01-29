class TaskOverridePolicy
  def initialize(user, task)
    @user = user
    @task = task
  end

  def allow?
    return false unless same_account?
    return false unless @user.manager?
    return false if task_completed_and_approved?

    true
  end

  def same_account?
    @user.account_id == @task.activity.account_id
  end

  def task_completed_and_approved?
    @task.approved?
  end
end

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def admin?
    user.admin?
  end

  def parent?
    user.parent?
  end

  def child?
    user.child?
  end

  def same_account?
    record.respond_to?(:account_id) &&
      record.account_id == user.account_id
  end
end

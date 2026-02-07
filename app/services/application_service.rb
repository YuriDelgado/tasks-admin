class ApplicationService
  private

  def authorize!(user, record, action)
    policy = policy_for(record).new(user, record)

    unless policy.public_send("#{action}?")
      raise ActiveRecord::RecordInvalid.new(record)
    end
  end

  def policy_for(record)
    "#{record.class}Policy".constantize
  end
end

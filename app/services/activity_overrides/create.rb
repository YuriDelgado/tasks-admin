class ActivityOverrides::Create < ApplicationService
  def initialize(user:, activity:, assigned_to:, date_from:, date_to:, reason:)
    @user = user
    @activity = activity
    @assigned_to = assigned_to
    @date_from = date_from
    @date_to = date_to
    @reason = reason
  end

  def call
    override = ActivityOverride.new(
      activity: activity,
      assigned_to: assigned_to,
      date_from: date_from,
      date_to: date_to,
      reason: reason,
      created_by: user
    )

    authorize!(user, override, :create)

    override.save!
    override.apply!

    override
  end

  private

  attr_reader :user, :activity, :assigned_to, :date_from, :date_to, :reason
end

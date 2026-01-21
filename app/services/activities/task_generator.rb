class Activities::TaskGenerator
  def initialize(activity, start_date: Time.current)
    @activity = activity
    @start_date = start_date
  end

  def generate!
    assignees = @activity.assignees
    raise "No assignees defined" if assignees.empty?

    @activity.times_per_period.times do |i|
      Task.create!(
        activity: @activity,
        assigned_to: assignees[i % assignees.size],
        due_on: due_on_for(i),
        status: :pending
      )
    end
  end

  private

  def due_on_for(index)
    case @activity.period
    when "week"
      @start_date.beginning_of_week + index.days
    when "day"
      @start_date + index.hours
    else
      @start_date + index.days
    end
  end
end

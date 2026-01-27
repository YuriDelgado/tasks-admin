class Activity < ApplicationRecord
  belongs_to :account
  belongs_to :user # creator
  has_many :tasks, dependent: :destroy
  has_many :activity_assignments, -> { order(:position) }, dependent: :destroy
  has_many :assignees, through: :activity_assignments, source: :user

  validates :name, presence: true
  validates :period, presence: true
  validates :frequency, numericality: { greater_than: 0 }
  validates :times_per_period, numericality: { greater_than: 0 }
  validate :valid_status_transition, on: :update
  validate :cannot_add_tasks_if_active, on: :update
  validate :immutable_fields_when_activity_active, on: :update

  enum :status, {
    draft: "draft",
    active: "active",
    archived: "archived"
  }

  enum :period, {
    day:   "day",
    week:  "week",
    month: "month"
  }

  enum :activity_type, {
    chore: "chore",
    habit: "habit",
    maintenance: "maintenance"
  }

  def activate!
    raise "Activity already active" if active?
    raise "No assignees defined" if assignees.empty?
    raise "Activity must have at least one task" if tasks.empty?

    Activities::TaskGenerator.new(self).generate!
    update!(status: :active)
  end

  # def next_assignee(index)
  #   assignees[index % assignees.size]
  # end

  def assignee_for(index)
    assignees[index % assignees.size]
  end

  def generate!
    Activities::TaskGenerator.new(self).generate!
  end

  def archive!
    raise "Only active activities can be archived" unless active?

    archived!
  end

  def next_assignee
    raise "No assignees defined" if activity_assignments.empty?

    last_task = tasks.order(created_at: :desc).first

    return activity_assignments.first.user unless last_task

    assignments = activity_assignments.to_a

    last_index = assignments.index do |assignment|
      assignment.user_id == last_task.assigned_to_id
    end
    # Safety fallback (override/manual assignment)
    return assignments.first.user if last_index.nil?

    next_assignment = assignments[last_index + 1] || assignments.first
    next_assignment.user
  end

  def generate_tasks!(from:, to:)
    raise "Activity must be active" unless active?
    raise "No assignees defined" if activity_assignments.empty?

    dates = generation_dates(from:, to:)

    dates.each do |date|
      next if tasks.exists?(due_on: date)

      Task.create!(
        activity: self,
        assigned_to: next_assignee,
        due_on: date
      )
    end
  end

  private

  def valid_status_transition
    return unless status_changed?

    from, to = status_change

    allowed = case from
    when "draft"    then %w[active]
    when "active"   then %w[archived]
    when "archived" then []
    else []
    end

    return if allowed.include?(to)

    errors.add(:status, "cannot transition from #{from} to #{to}")
  end

  def cannot_add_tasks_if_active
    return unless active?
    return unless tasks.any?(&:new_record?)

    errors.add(:tasks, "cannot be added once the activity is active")
  end

  def activity_must_be_active
    return if task.activity.active?

    errors.add(:base, "Cannot override task from inactive activity")
  end

  def immutable_fields_when_activity_active
    return unless active?

    immutable_fields = %i[
      period
      frequency
      times_per_period
    ]

    immutable_fields.each do |field|
      if will_save_change_to_attribute?(field)
        errors.add(field, "cannot be changed once the activity is active")
      end
    end
  end

  def generation_dates(from:, to:)
    case period.to_sym
    when :day
      (from..to).to_a
    when :week
      generate_weekly_dates(from, to)
    when :month
      generate_monthly_dates(from, to)
    else
      raise "Unknown period"
    end
  end

  def generate_weekly_dates(from, to)
    weeks = (from..to).group_by(&:cweek)

    weeks.flat_map do |_week, days|
      days.first(times_per_period)
    end
  end

  def generate_monthly_dates(from, to)
    months = (from..to).group_by { |d| [ d.year, d.month ] }

    months.flat_map do |_month, days|
      days.first(times_per_period)
    end
  end
end

class Activity < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :activity_assignments, -> { order(:position) }, dependent: :destroy
  has_many :assignees, through: :activity_assignments, source: :user

  validates :name, presence: true
  validates :period, presence: true
  validates :frequency, numericality: { greater_than: 0 }
  validates :times_per_period, numericality: { greater_than: 0 }
  validate :valid_status_transition, on: :update
  validate :cannot_add_tasks_if_active, on: :update
  # validate :activity_must_be_active

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
    # raise "Activity must have at least one task" if tasks.empty?

    Activities::TaskGenerator.new(self).generate!
    update!(status: :active)
  end

  def next_assignee(index)
    assignees[index % assignees.size]
  end

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
end

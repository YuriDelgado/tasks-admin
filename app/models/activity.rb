class Activity < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :activity_assignments, -> { order(:position) }, dependent: :destroy
  has_many :assignees, through: :activity_assignments, source: :user

  validates :name, presence: true
  validates :period, presence: true
  validates :frequency, numericality: { greater_than: 0 }
  validates :times_per_period, numericality: { greater_than: 0 }

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
end

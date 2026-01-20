class Activity < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

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
    raise "Activity must have at least one task" if tasks.empty?

    update!(status: :active)
  end
end

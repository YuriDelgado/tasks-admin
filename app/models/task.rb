class Task < ApplicationRecord
  belongs_to :activity
  belongs_to :assignee, class_name: "User"

  validates :due_on, presence: true

  enum :status, {
    pending:   "pending",
    completed: "completed",
    approved:  "approved",
    rejected:  "rejected",
    canceled:  "canceled"
  }, prefix: true

  ALLOWED_TRANSITIONS = {
    pending:   [ :completed ],
    completed: [ :approved, :rejected ],
    rejected:  [ :completed ],
    approved:  []
  }.freeze

  ROLE_TRANSITIONS = {
    child: {
      pending:  [ :completed ],
      rejected: [ :completed ]
    },
    parent: {
      completed: [ :approved, :rejected ]
    }
  }.freeze

  def can_transition_to?(new_status, role:)
    ROLE_TRANSITIONS
      .dig(role.to_sym, status.to_sym)
      &.include?(new_status.to_sym)
  end

  def transition_to!(new_status, role:)
    unless can_transition_to?(new_status, role: role)
      raise ArgumentError, "Invalid transition"
    end

    update!(
      status: new_status,
      completed_at: (Time.current if new_status.to_sym == :completed)
    )
  end
end

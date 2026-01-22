class Task < ApplicationRecord
  belongs_to :activity
  belongs_to :assigned_to, class_name: "User"
  has_one :task_override, dependent: :destroy

  # validates :due_on, presence: true
  validate :immutable_fields_when_activity_active, on: :update

  before_destroy :prevent_destroy_if_activity_active

  enum :status, {
    pending:   "pending",
    completed: "completed",
    approved:  "approved",
    rejected:  "rejected",
    canceled:  "canceled"
  }

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

  def effective_assigned_to
    task_override&.assigned_to || assigned_to
  end

  def effective_due_on
    task_override&.due_on || due_on
  end

  private

  def immutable_fields_when_activity_active
    return unless activity&.active?

    immutable_fields = %i[
      activity_id
      assigned_to_id
      due_on
    ]

    immutable_fields.each do |field|
      if will_save_change_to_attribute?(field)
        errors.add(field, "cannot be changed once the activity is active")
      end
    end
  end

  def prevent_destroy_if_activity_active
    return unless activity&.active?

    errors.add(:base, "tasks cannot be removed once the activity is active")
    throw(:abort)
  end
end

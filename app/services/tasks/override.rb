module Tasks
  class Override
    def self.call(...)
      new(...).call
    end

    def initialize(task:, actor:, assigned_to: nil, due_on: nil, reason: nil)
      @task = task
      @actor = actor
      @assigned_to = assigned_to
      @due_on = due_on
      @reason = reason
    end

    def call
      authorize!
      validate!

      override = task.task_override || task.build_task_override

      override.assign_attributes(
        assigned_to: assigned_to,
        due_on: due_on,
        reason: reason,
        overridden_by: actor
      )

      override.save!
      override
    end

    private

    attr_reader :task, :actor, :assigned_to, :due_on, :reason

    def authorize!
      raise UnauthorizedError unless TaskOverridePolicy.new(@actor, @task).allow?
    end

    def validate!
      raise "Task activity must be active" unless task.activity.active?

      if assigned_to.nil? && due_on.nil?
        raise ArgumentError, "Nothing to override"
      end
    end
  end
end

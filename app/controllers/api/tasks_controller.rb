module Api
  class TasksController < Api::BaseController
    before_action :set_task, only: %i[ show transition ]

    def index
      @tasks = current_account.tasks
      render json: @tasks
    end

    def show
      render json: @task
    end

    def transition
      new_status = transition_params[:new_status]
      policy = TaskPolicy.new(current_user, @task)

      unless policy.public_send("#{new_status}?")
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      @task.transition_to!(new_status)
      render json: @task
    end

    private

    def set_task
      @task = current_account.tasks.find(params[:id] || transition_params[:task_id])
    end

    def transition_params
      params.permit(:task_id, :new_status, :role)
    end
  end
end

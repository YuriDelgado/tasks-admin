class Api::TaskOverridesController < Api::BaseController
  def create
    task = current_user.account.tasks.find(params[:task_id])

    override = task.build_task_override(
      override_params.merge(overridden_by: current_user)
    )

    if override.save
      render json: override, status: :created
    else
      render json: { errors: override.errors.full_messages }, status: :forbidden
    end
  end
end

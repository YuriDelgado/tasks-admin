module Api
  class ActivitiesController < Api::BaseController
    before_action :set_activity, only: %i[ show ]

    def index
      @activities = current_account.activities
      render json: @activities
    end

    def show
      render json: @activities
    end

    private

    def set_activity
      @activities = current_account.activities.find(params[:id])
    end
  end
end

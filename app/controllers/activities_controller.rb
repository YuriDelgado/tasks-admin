class ActivitiesController < AuthenticatedController
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities or /activities.json
  def index
    @activities = current_account.activities
  end

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities or /activities.json
  def create
    @activity = current_account.activities.new(activity_params)
    @activity.user = current_user

    if @activity.save
      redirect_to @activity, notice: "Activity was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: "Activity was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy!

    redirect_to activities_path, notice: "Activity was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = current_account.activities.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_params
      params.expect(activity: [ :name, :description, :user_id, :status, :period, :activity_type, :frequency, :times_per_period ])
    end
end

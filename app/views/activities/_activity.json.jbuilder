json.extract! activity, :id, :name, :description, :user_id, :status, :period, :activity_type, :frequency, :times_per_period, :created_at, :updated_at
json.url activity_url(activity, format: :json)

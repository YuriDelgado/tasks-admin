json.extract! task, :id, :activity_id, :status, :due_to, :completed_at, :created_at, :updated_at
json.url task_url(task, format: :json)

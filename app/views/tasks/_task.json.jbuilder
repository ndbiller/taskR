json.extract! task, :id, :name, :user_id, :active, :duration, :created_at, :started_at, :stopped_at, :created_at, :updated_at
json.url task_url(task, format: :json)
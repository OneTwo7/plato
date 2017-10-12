json.extract! lesson, :id, :name, :content, :path_id, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)

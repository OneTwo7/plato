json.extract! @path
json.extract! lesson, :id, :name, :content, :path_id, :created_at, :updated_at
json.url path_lesson_url(@path, lesson, format: :json)

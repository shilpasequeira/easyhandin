json.array!(@courses) do |course|
  json.extract! course, :id, :name, :slug, :is_published, :test_repository
  json.url course_url(course, format: :json)
end

json.array!(@teams) do |team|
  json.extract! team, :id, :name, :slug, :repository
  json.url team_url(team, format: :json)
end

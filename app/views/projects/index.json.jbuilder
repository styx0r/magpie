json.array!(@projects) do |project|
  json.extract! project, :id, :user, :job_id, :name, :model, :output, :resultfiles
  json.url project_url(project, format: :json)
end

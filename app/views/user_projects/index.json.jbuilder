json.array!(@user_projects) do |user_project|
  json.extract! user_project, :id, :user, :job_id, :name
  json.url user_project_url(user_project, format: :json)
end

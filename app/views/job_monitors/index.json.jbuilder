json.array!(@job_monitors) do |job_monitor|
  json.extract! job_monitor, :id, :job_id, :user
  json.url job_monitor_url(job_monitor, format: :json)
end

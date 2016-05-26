json.array!(@jobs) do |job|
  json.extract! job, :id, :status
  json.url job_url(job, format: :json)
end

module DashboardHelper

  def count_jobs(status)
    JobMonitor.where(:status => status).count
  end
end

module DashboardHelper

  def count_jobs(status)
    JobMonitor.where(:status => status).count
  end

  def count_jobs_user(status)
      JobMonitor.where(:user => current_user.id, :status => status).count
  end
end

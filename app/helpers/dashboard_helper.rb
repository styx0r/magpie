module DashboardHelper

  def count_jobs(status)
    JobMonitor.where(:status => status).count
  end

  def count_jobs_user(status)
    user = User.find_by(id: session[:user_id]).name
    JobMonitor.where(:user => user, :status => status).count
  end
end

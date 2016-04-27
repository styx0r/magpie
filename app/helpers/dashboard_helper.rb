module DashboardHelper

  def count_jobs(status)
    JobMonitor.where(:status => status).count
  end

  def count_jobs_user(status)
    user = User.find_by(id: session[:user_id])
    if user == nil
      0
    else
      JobMonitor.where(:user => user.name, :status => status).count
    end
  end
end

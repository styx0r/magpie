module DashboardHelper

  def count_jobs(status)
    Job.where(:status => status).count
  end

  def count_jobs_user(status)
      Job.where(:user_id => current_user.id, :status => status).count
  end
end

module DashboardHelper

  def count_jobs(status)
    Job.where(:status => status).count
  end

  def count_jobs_user(status)
      Job.where(:user_id => current_user.id, :status => status).count
  end

  def load_image()
    if Rails.application.config.worker_number/4 >= count_jobs("running")
      return("cpublack.svg")
    elsif Rails.application.config.worker_number/2 >= count_jobs("running")
      return("cpuyellow.png")
    elsif (Rails.application.config.worker_number/4 * 3) >= count_jobs("running")
      return("cpuorange.png")
    else
      return("cpured.png")
    end
  end

end

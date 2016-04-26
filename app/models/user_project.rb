class UserProject < ActiveRecord::Base

  def status()
    jobmon = JobMonitor.where(:job_id => self.job_id).first
    if jobmon == nil
      "unknown"
    else
      jobmon.status
    end
  end

end

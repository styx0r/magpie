class UserProject < ActiveRecord::Base
  serialize :output  # output is a hash, so serialize it

  def status()
    jobmon = JobMonitor.where(:job_id => self.job_id).first
    if jobmon == nil
      "unknown"
    else
      jobmon.status
    end
  end

end

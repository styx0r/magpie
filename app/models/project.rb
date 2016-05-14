class Project < ActiveRecord::Base
  belongs_to :user
  serialize :output  # output is a hash, so serialize it
  serialize :resultfiles

  def status()
    jobmon = JobMonitor.where(:job_id => self.job_id).first
    if jobmon == nil
      "unknown"
    else
      jobmon.status
    end
  end

end

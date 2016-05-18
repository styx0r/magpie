class Project < ActiveRecord::Base
  belongs_to :user
  has_many :jobs
  serialize :output  # output is a hash, so serialize it
  serialize :resultfiles

  def status()
    jobmon = Job.where(:active_job_id => self.job_id).first
    if jobmon == nil
      "unknown"
    else
      jobmon.status
    end
  end

end

class UserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # For now, log something
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"
    sleep(20) # Job takes 20 seconds...
  end

  around_perform do |job, block|
    puts "[Job: #{self.job_id}] Before performing ..."
    this_job = JobMonitor.find_by(job_id: self.job_id)
    this_job.update(status: "running")
    block.call
    puts "[Job: #{self.job_id}] I successfully finished my job."
    this_job.update(status: "finished")
  end

  around_enqueue do |job, block|
    puts "[Job: #{self.job_id}] Before enqueing ... "
    #TODO Insert user from arguments (args)
    JobMonitor.create(job_id: self.job_id, user: "?", status: "waiting")
    block.call
    puts "[Job: #{self.job_id}] After enqueing ..."
  end

end

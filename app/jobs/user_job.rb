class UserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # For now, log something
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"
    sleep(10)
  end

  around_perform do |job, block|
    puts "[Job: #{self.job_id}] Before performing ..."
    block.call
    puts "[Job: #{self.job_id}] I successfully finished my job."
  end

  around_enqueue do |job, block|
    puts "[Job: #{self.job_id}] Before enqueing ... "
    block.call
    puts "[Job: #{self.job_id}] After enqueing ..."
  end

end

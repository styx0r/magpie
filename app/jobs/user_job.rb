class UserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"

    # For now, execute a shell script which sleeps and then prints the arguments
    arg1 = "arg1"
    arg2 = "another_arg"
    modelscript = args[0]["model"]
    Open3.popen3(modelscript, arg1 + " " + arg2) do |stdin, stdout, stderr|
      stdin.close  # make sure the subprocess is done
      @stdout = stdout.gets
      @stderr = stderr.gets

      # Put stdout and stderr output into project output var and save
      project = UserProject.find_by(job_id: self.job_id)
      project.output = {stdout: @stdout, stderr: @stderr}
      project.save
    end
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
    args = job.arguments[0]
    puts "[Job: #{self.job_id}] Before enqueing ... "
    JobMonitor.create(job_id: self.job_id, user: args["user"], status: "waiting")
    block.call
    puts "[Job: #{self.job_id}] After enqueing ..."
  end

end

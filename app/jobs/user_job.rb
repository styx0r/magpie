class UserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"

    #TODO Refactor into functions ...

    # For now, execute a shell script which sleeps and then prints the arguments
    arg1 = "arg1"
    arg2 = "another_arg"
    modelscript = args[0]["model"]
    user = args[0]["user"]

    ### Create the tmp user working directory (not used yet)
    dir = File.dirname("#{Rails.root}/user/#{user}/#{self.job_id}/.to_path")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    @modelpath = modelscript.to_s
    @symlinkmodel = dir.to_s + "/runmodel.sh"
    `ln -s #{@modelpath} #{@symlinkmodel}`
    @project = UserProject.find_by(job_id: self.job_id)

    ### Go to the temporary working directory and execute the script
    Dir.chdir(dir) do
      Open3.popen3(@symlinkmodel, arg1 + " " + arg2) do |stdin, stdout, stderr|
        stdin.close  # make sure the subprocess is done
        @stdout = stdout.gets
        @stderr = stderr.gets

        # Put stdout and stderr output into project output var and save
        @project.output = {stdout: @stdout, stderr: @stderr}
        @project.save
      end
    end

    resultfiles = Dir.glob(Rails.root.join(dir, '*'))
    resultfiles.delete(@symlinkmodel)
    @project.resultfiles = resultfiles
    @project.save

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

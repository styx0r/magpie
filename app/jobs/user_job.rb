class UserJob < ActiveJob::Base
  queue_as :default

  rescue_from(StandardError) do |ex|
  #TODO Right now, should catch each error
  puts "[Job: #{self.job_id}] I failed! Script is okay, please check Rails code or server."
  puts ex.inspect
  @job.update(status: "failed")
  end

  def perform(*args)
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"
    user = self.arguments.first
    @userdir = File.dirname("#{Rails.root}/user/#{user.id.to_s}/#{self.job_id}/.to_path")
    modelscript = self.arguments.last["model"]
    @originaldir = File.dirname(modelscript)
    @symlinkmodel = @userdir.to_s + "/" + File.basename(modelscript)
    @project = Project.find_by(job_id: self.job_id)

    #TODO Add handling and passing of arguments
    @arg1, @arg2 = "arg1", "arg2"


    create_tmpdir_with_symlinks

    process = execute_script
    @return_val = process.exitstatus

    @project.output = {stdout: @stdout, stderr: @stderr}
    @project.save

    delete_symlinks

    @project.resultfiles = Dir.glob(Rails.root.join(@userdir, '*'))
    @project.save

    zip_result_files

  end

  around_perform do |job, block|
    puts "[Job: #{self.job_id}] Before performing ..."
    block.call
    @job = self.arguments[1]
    if @return_val != 0
      puts "[Job: #{self.job_id}] I failed. The script has an exit value of #{@return_val}."
      @job.update(status: "failed")
    else
      puts "[Job: #{self.job_id}] I successfully finished my job."
      @job.update(status: "finished")
    end
  end

  around_enqueue do |job, block|
    user = job.arguments[0]
    puts "[Job: #{self.job_id}] Before enqueing ... "
    @job = self.arguments[1]
    @job.update(status: "waiting", active_job_id: self.job_id)
    block.call
    @job.update(status: "running")
    puts "[Job: #{self.job_id}] After enqueing ..."
  end

  def zip_result_files
    ## Now, create a zipped archive of all resultfiles, if there are any
    require 'zip'
    zipfile_name = @userdir + "/all-resultfiles-#{@project.name}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      @project.resultfiles.each do |resultfile|
        zipfile.add(File.basename(resultfile), resultfile)
      end
    end
  end

  def delete_symlinks
    # Cleans up symlinks after processing a job
    modelfiles = Dir.glob(@originaldir + "/*")
    modelfiles.each do |modelfile|
      symlink = @userdir.to_s + '/' + File.basename(modelfile)
      File.delete(symlink)
    end
  end

  def execute_script
    ### Go to the temporary working directory and execute the script
    #TODO for mf script, not the entire stdout and stderr is retrieved
    Dir.chdir(@userdir) do
      Open3.popen3(@symlinkmodel, @arg1 + " " + @arg2) do |stdin, stdout, stderr, thread|
        stdin.close  # make sure the subprocess is done
        @stdout = stdout.gets
        @stderr = stderr.gets
        thread.value # Return value
      end
    end
  end

  def create_tmpdir_with_symlinks
    ### Create a tmp user dir and symlinks for model files
    FileUtils.mkdir_p(@userdir) unless File.directory?(@userdir)

    modelfiles = Dir.glob(@originaldir + "/*")
    modelfiles.each do |modelfile|
      symlink = @userdir.to_s + '/' + File.basename(modelfile)
      `ln -sf #{modelfile} #{symlink}`
    end
  end



end

class UserJob < ApplicationJob
#class UserJob < ActiveJob::Base
  queue_as :userjobs

  rescue_from(StandardError) do |ex|
  p "[Job: #{self.job_id}] I failed! Script is okay, please check Rails code or server."
  p ex.inspect
  @job.update(status: "failed")
  end

  def perform(*args)
    @config_params = self.arguments[1]
    @job = self.arguments.first
    @project = @job.project
    user = @job.user
    p "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"
    @userdir = File.dirname("#{Rails.application.config.user_output_path}#{user.id.to_s}/#{self.job_id}/.to_path")
    @job.directory = @userdir.to_s
    mainscript = @job.project.model.mainscript
    @originaldir = @job.project.model.path
    modelscript = "#{@originaldir}/#{mainscript}"
    @symlinkmodel = @userdir.to_s + "/" + File.basename(modelscript)

    create_tmpdir_with_symlinks

    if !@config_params.nil?
      create_configs
    end

    process = execute_script

    @return_val = process.exitstatus

    @job.output = {stdout: @stdout, stderr: @stderr}

    delete_symlinks

    @job.resultfiles = Dir.glob(Rails.root.join(@userdir, '*'))
    @job.save

    zip_result_files

  end

  around_perform do |job, block|
    @job = self.arguments.first
    @job.update(status: "running")
    notify
    puts "[Job: #{self.job_id}] Before performing ..."
    block.call
    if @return_val != 0
      puts "[Job: #{self.job_id}] I failed. The script has an exit value of #{@return_val}."
      @job.update(status: "failed")
    else
      puts "[Job: #{self.job_id}] I successfully finished my job."
      @job.update(status: "finished")
    end
    notify
  end

  around_enqueue do |job, block|
    puts "[Job: #{self.job_id}] Before enqueing ... "
    @job = self.arguments.first
    @job.update(status: "waiting")
    notify
    block.call
    puts "[Job: #{self.job_id}] After enqueing ..."
    notify
  end

  def zip_result_files
    ## Now, create a zipped archive of all resultfiles, if there are any
    require 'zip'
    zipfile_name = "#{@userdir}/all-resultfiles-#{@project.name}-#{@job.id.to_s}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      @job.resultfiles.each do |resultfile|
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
      Open3.popen3('sh ' + @symlinkmodel) do |stdin, stdout, stderr, thread|
        stdin.close  # make sure the subprocess is done
        @stdout = stdout.gets
        @stderr = stderr.gets
        thread.value # Return value
      end
    end
  end

  def create_configs
    p "orig dir: #{@originaldir}"
    p "model dir: #{@userdir}"

    # get config files
    configfiles = Dir.glob(@originaldir + "/*.config")

    keys = @config_params.keys

    for configfile in configfiles
      require("csv")
      file_string = CSV.read(configfile)
      config_name = configfile.split("/").last
      config_path = @userdir+"/"+config_name
      config_file = File.open(config_path, "w")
      for line in file_string
        if line.empty?
          next
        elsif line.first[0] == "#" || line.first[0] == " " || line.first[0] == "/"
          config_file.puts line.first
        else
          line = line.first.gsub(/\s+/m, ' ').strip.split(" ")
          if line.length == 1
            config_file.puts line
            next
          end
          config_file.puts line[0] + " " + @config_params[config_name+"_"+line[0]]
        end
      end
      config_file.close
    end

  end

  def create_tmpdir_with_symlinks
    ### Create a tmp user dir and symlinks for model files
    FileUtils.mkdir_p(@userdir) unless File.directory?(@userdir)

    # link all files but config
    modelfiles = Dir.glob(@originaldir + "/*")
    modelfiles.each do |modelfile|
      if modelfile.split(".").last == "config"
        next
      end
      symlink = @userdir.to_s + '/' + File.basename(modelfile)
      `ln -sf #{modelfile} #{symlink}`
    end
  end

  protected
    def notify
      ActionCable.server.broadcast("job_queue_infos",
        all_queue: Job.where(:status => "waiting").count)
      # Announcing changes in the job status
      ActionCable.server.broadcast("job_queue_infos_#{@job.user_id}",
        me_queue: Job.where(:user_id => @job.user_id, :status => "waiting").count,
        me_running: Job.where(:user_id => @job.user_id, :status => "running").count,
        me_finished: Job.where(:user_id => @job.user_id, :status => "finished").count,
        me_failed: Job.where(:user_id => @job.user_id, :status => "failed").count)
    end

end

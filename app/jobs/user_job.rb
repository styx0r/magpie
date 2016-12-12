class UserJob < ApplicationJob
#class UserJob < ActiveJob::Base
  queue_as :userjobs

  rescue_from(StandardError) do |ex|
  p "[Job: #{self.job_id}] I failed! Script is okay, please check Rails code or server."
  p ex.inspect
  @job.update(status: "failed")
  end

  def perform(*args)
    @config_params = self.arguments[1][:config]
    @uploads = self.arguments[1][:uploads]
    @job = self.arguments.first
    @project = @job.project
    user = @job.user
    p "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"
    @userdir = File.dirname("#{Rails.application.config.jobs_path}#{user.id.to_s}/#{self.job_id}/.to_path")
    @job.directory = @userdir.to_s

    system("git clone #{@job.project.model.path}  #{@userdir}")
    system("cd #{@userdir}; git reset --hard #{@project.revision}")

    files_before = Dir.glob(Rails.root.join(@userdir, '*'))

    # Copy the uploaded files to the directory
    @uploads.each do |key, value|
      FileUtils.cp value[0], "#{@userdir}/"+value[1]
    end

    if !@config_params.nil?
      create_configs
    end

    @return_val = execute_script

    @job.output = {stdout: @stdout, stderr: @stderr}

    files_after = Dir.glob(Rails.root.join(@userdir, '*'))
    @job.resultfiles = files_after.reject{|fil| files_before.include? fil}
    @job.save
    @job.zip_result_files

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

  def execute_script
    ### Go to the temporary working directory and execute the script
    Dir.chdir(@userdir) do

      @job.docker_id = docker_image_id = `docker images -q magpie:default`.squish      

      container = Docker::Container.create('Image' => 'magpie:default',
                                           'Tty' => true,
                                           'Binds' => ["#{@userdir}:/root/job:rw"])
      container.start()
      #container.wait(100)
      c_out = container.exec(["/bin/bash", "-c", "cd /root/job; sh #{@job.project.model.mainscript[@job.project.revision]}"],
                             wait: Rails.application.config.docker_timeout)
      container.stop
      container.remove
      @stdout = c_out[0]
      @stderr = c_out[1]
      c_out[2]
    end
  end

  def create_configs
    p "orig dir: #{@originaldir}"
    p "model dir: #{@userdir}"

    # get config files
    configfiles = Dir.glob(@userdir + "/*.config")

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
          if line[0] == "depends_on"
            next
          end
          if line.length == 1
            config_file.puts line
            next
          end
          if @config_params.key? config_name+"_"+line[0]
            config_file.puts line[0] + " " + @config_params[config_name+"_"+line[0]]
          else
            config_file.puts line[0] + " " + line[2]
          end
        end
      end
      config_file.close
    end

  end

  protected
    def notify

      Thread.new {

        sleep(1)

        ActionCable.server.broadcast("job_queue_infos",
          all_queue: Job.where(:status => "waiting").count)
        # Announcing changes in the job status
        ActionCable.server.broadcast("job_queue_infos_#{@job.user_id}",
          me_queue: Job.where(:user_id => @job.user_id, :status => "waiting").count,
          me_running: Job.where(:user_id => @job.user_id, :status => "running").count,
          me_finished: Job.where(:user_id => @job.user_id, :status => "finished").count,
          me_failed: Job.where(:user_id => @job.user_id, :status => "failed").count,
          job_id: @job.id)

      }
    end

end

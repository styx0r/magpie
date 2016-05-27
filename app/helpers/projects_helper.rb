module ProjectsHelper
  require 'ruby-filemagic'
  require 'mime/types'

  def list_models()
    # Only find shell scripts
    Dir.glob(Rails.root.join('bin', 'models', '*/*.sh'))
  end

  def status_color_panel jobid
    # Return color for buttons based on status
    job = @project.jobs.find_by(id: jobid)
    if job.status == "finished"
      'panel-success'  # Finished
    elsif job.status == "running"
      'panel-warning'  # Running
    elsif job.status == "failed"
      'panel-danger'  # Failed
    else
      'panel-default'  # Neutral
    end
  end

  def numResultfiles jid
    job = @project.jobs.find_by(id: jid)
    job.resultfiles.size
  end




end

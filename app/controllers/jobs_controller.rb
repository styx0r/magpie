class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :download, :download_config, :images, :highlight]
  skip_before_filter :verify_authenticity_token, :only => [:running]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = policy_scope(Job)
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find_by id: params[:id]
    authorize @job
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find_by id: params[:id]
    authorize @job
  end

  def running
    authorize Job

    job_id = params[:job_id].to_i
    job = Job.find_by_id job_id
    render :layout => false, partial: 'jobs/running', locals: {:job => job}
  end

  def read_more

    job_id = params[:job_id].to_i
    job = Job.find_by_id job_id

    authorize job

    type = params[:type]

    render :layout => false, partial: 'jobs/read_more', locals: {:job => job, :type => type}
  end

  def read_less

    job_id = params[:job_id].to_i
    job = Job.find_by_id job_id

    authorize job

    type = params[:type]

    render :layout => false, partial: 'jobs/read_less', locals: {:job => job, :type => type}
  end

  # POST /jobs
  # POST /jobs.json
  def create

    @job = Job.new(job_params)
    authorize @job

    uploads = {}
    config_params_mod = config_params
    config_params.each do |key, value|
      if !(defined? value.tempfile).nil?
        uploads[key] = [value.tempfile.path, value.original_filename]
        config_params_mod[key] = value.original_filename
      end
    end

    # Also, start a delayed job
    @user_job = UserJob.perform_later(@job, {:config => config_params_mod, :uploads => uploads})


    respond_to do |format|
      if @job.save
        format.html { redirect_to user_project_path(@job.user.id, @job.project.id) }
        flash['success'] = "Job was successfully created."
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job }
        flash['success'] = "Job was successfully updated."
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    authorize @job
    @job.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      flash['warning'] = "Job was successfully destroyed."
      format.json { head :no_content }
    end
  end

  def download
    authorize @job
    # Initializes file download
    dir = @job.directory
    zipfile = "#{dir}/all-resultfiles-#{@job.project.name}-#{@job.id.to_s}.zip"
    send_file zipfile, :type => 'application/zip', :disposition => 'attachment', :filename => "results_#{@job.project.name}_#{@job.id.to_s}.zip"
  end

  def download_config
    authorize @job
    # Initializes file download
    dir = @job.directory
    zipfile = "#{dir}/config-#{@job.project.name}-#{@job.id.to_s}.zip"
    send_file zipfile, :type => 'application/zip', :disposition => 'attachment', :filename => "config_#{@job.project.name}_#{@job.id.to_s}.zip"
  end

  def highlight
    authorize @job
    respond_to do |format|
      if @job.update(highlight_params)
        format.html { redirect_to @job.project }
        flash['success'] = "Job was successfully updated."
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end

  end

  def images
    authorize Job
    #TODO Handle missing images
    fileid = params[:fileid].to_i
    send_file(@job.resultfiles[fileid])
  end

  def status
    render :layout => false, file: 'shared/_footer_job_status'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:status, :user_id, :project_id, :arguments, :config, :usertags, :highlight)
    end

    def highlight_params
      params.require(:job).permit(:highlight)
    end


    def config_params
      # Config parameter set
      if params[:job][:config].present?
        params[:job].require(:config).permit!.to_h
      else
        p "Empty parameter set"
        {:config => {}}
      end
    end
end

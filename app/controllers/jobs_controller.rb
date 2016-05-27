class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :download, :images]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    # Also, start a delayed job
    @user_job = UserJob.perform_later(@job)


    respond_to do |format|
      if @job.save
        format.html { redirect_to user_project_path(@job.user.id, @job.project.id), notice: 'Job was successfully created.' }
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
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
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
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    #TODO Handle case when there are no output files!
    #TODO Save userdir as attribute in jobs!
    dir = @job.directory
    #dir = File.dirname("#{Rails.root}/user/#{@job.user.id.to_s}/#{@job.id}/.to_path")
    zipfile = "#{dir}/all-resultfiles-#{@job.project.name}-#{@job.id.to_s}.zip"
    send_file(zipfile)
  end

  def images
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
      params.require(:job).permit(:status, :user_id, :project_id, :arguments)
    end
end

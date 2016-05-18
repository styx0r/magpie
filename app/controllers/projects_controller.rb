class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :download, :images]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :destroy_all, :download, :images]

  def download
    #TODO Check for ownership of project!
    #TODO Checking user etc. should be easier now with nesting
    #TODO For now, it only sends the first result file, we want to zip and send all!
    #TODO Handle case when there are no output files!
    dir = File.dirname("#{Rails.root}/user/#{@project.user}/#{@project.job_id}/.to_path")
    zipfile = "#{dir}/all-resultfiles-#{@project.name}.zip"
    send_file(zipfile)
  end

  def images
    #TODO Handle missing images
    fileid = params[:fileid].to_i
    send_file(@project.resultfiles[fileid])
  end

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    # First, create the project itself
    @user = current_user
    #@project = Project.new(project_params)
    @project = @user.projects.create(project_params)
    # Then, start the job
    job = Job.create(status: "waiting", user_id: current_user.id)
    @user_job = UserJob.perform_later(@user, job, project_params)
    @project.update(:job_id =>@user_job.job_id)

    respond_to do |format|
      if @project.save
        format.html { redirect_to user_project_path(current_user, @project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    if !@user.projects.blank?
      @user.projects.destroy_all
    end
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'All projects have been deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:job_id, :name, :model)
    end
end

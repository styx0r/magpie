class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :destroy_all, :images]
  before_action :correct_user, only: [:download]





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
    @project = @user.projects.create(project_params)
    # Then, start the job
    job = Job.create(status: "waiting", user_id: current_user.id, project_id: @project.id)
    @user_job = UserJob.perform_later(job, project_params)

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

    def correct_user
      @project = Project.find(params[:project_id])
      redirect_to root_url if @project.user != current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:job_id, :name, :model)
    end
end

class UserProjectsController < ApplicationController
  before_action :set_user_project, only: [:show, :edit, :update, :destroy]

  # GET /user_projects
  # GET /user_projects.json
  def index
    @user_projects = UserProject.all
  end

  # GET /user_projects/1
  # GET /user_projects/1.json
  def show
  end

  # GET /user_projects/new
  def new
    @user_project = UserProject.new
  end

  # GET /user_projects/1/edit
  def edit
  end

  # POST /user_projects
  # POST /user_projects.json
  def create
    # First, start a new background job
    @user_job = UserJob.perform_later(user_project_params)
    # Then, create the project itself
    @user_project = UserProject.new(user_project_params)
    @user_project.update(:job_id =>@user_job.job_id)

    respond_to do |format|
      if @user_project.save
        format.html { redirect_to @user_project, notice: 'User project was successfully created.' }
        format.json { render :show, status: :created, location: @user_project }
      else
        format.html { render :new }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_projects/1
  # PATCH/PUT /user_projects/1.json
  def update
    respond_to do |format|
      if @user_project.update(user_project_params)
        format.html { redirect_to @user_project, notice: 'User project was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_project }
      else
        format.html { render :edit }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_projects/1
  # DELETE /user_projects/1.json
  def destroy
    @user_project.destroy
    respond_to do |format|
      format.html { redirect_to user_projects_url, notice: 'User project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_project
      @user_project = UserProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_project_params
      params.require(:user_project).permit(:user, :job_id, :name, :model)
    end
end

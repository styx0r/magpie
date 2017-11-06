class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :images, :toggle_public]
  before_action :correct_user, only: [:download]
  before_action :is_project_owner, only: [:destroy]

  # GET /projects
  # GET /projects.json
  def index
    authorize Project
    # Only index projects of the current user
    @projects = current_user.projects
    @public_projects = policy_scope(Project)
    @help_context = "Projects"
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find_by id: params[:id]
    authorize @project
    # New jobs can be created from the projects view
    @job = Job.new
  end

  # GET /projects/new
  def new
    authorize Project
    @project = Project.new
    @job = @project.jobs.new
    @model = params
  end

  # GET /projects/1/edit
  def edit
    authorize Project
  end

  def toggle_public
    authorize @project
    respond_to do |format|
    @project.public = !@project.public
    if @project.save
        format.html { redirect_to :back }
        flash['success'] = "Project was successfully updated."
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end

  end

  def modeldescription
    model_selected = Model.find_by id: params[:model_id]

    authorize Project

    if model_selected == NIL
      model_description = "nil"
    else
      model_description = model_selected.description
      model_help = model_selected.help
      doi = model_selected.doi
      citation = model_selected.citation
    end
    render :layout => false, partial: 'projects/modeldescription',
    locals: {:model_description => model_description,
             :doi => doi,
             :citation => citation,
             :model_help => model_help}
  end

  def delete_marked_jobs
    @project = Project.find(params[:project_id])
    authorize @project
    @project.jobs.where(:highlight => "hidden").destroy_all
    respond_to do |format|
      format.html { redirect_to :back }
      flash['warning'] = "All marked jobs have been deleted."
      format.json { head :no_content }
    end
  end

  def modelconfig

      model_selected = Model.find_by id: params[:model_id]

      authorize Project

      model_revision = params[:model_revision]
      render :layout => false, partial: 'projects/modelconfig',
        locals: { :model_selected => model_selected,
                  :model_revision => model_revision,
                  :f => nil }

  end

  def modelrevisions

      model_selected = Model.find_by id: params[:model_id]

      authorize Project

      render :layout => false, partial: 'projects/modelrevisions',
        locals: { :model_selected => model_selected,
                  :model_revisions => model_selected.versions }

  end

  # POST /projects
  # POST /projects.json
  def create
    authorize Project
    # First, create the project itself
    @user = current_user
    @project = @user.projects.create(project_params)
    @project.revision = @project.tag_to_revision(config_params[:revision])
    # Then, start the job
    uploads = {}
    config_params_mod = config_params
    config_params.each do |key, value|
      if !(defined? value.tempfile).nil?
        uploads[key] = [value.tempfile.path, value.original_filename]
        config_params_mod[key] = value.original_filename
      end
    end

    # Create jobs
    job = Job.create(job_params[:job].merge(:project_id => @project.id))

    @user_job = UserJob.perform_later(job, {:config => config_params_mod, :uploads => uploads})

    respond_to do |format|
      if @project.save
        # Save all user-supplied hashtags
        usertags = project_params[:usertags].split(/\s*[,;]\s*|\s{1,}/x)

        project_hashtag_format = /^[a-z0-9][a-z0-9]project[0-9]+$/
        model_hashtag_format = /^[a-z0-9][a-z0-9]model[0-9]+$/

        @project.assign_unique_hashtag

        usertags.each do |rawtag|
          tag = rawtag.to_s.downcase.gsub(/#/, '')
          if !(project_hashtag_format.match(tag) or model_hashtag_format.match(tag))
            if !Hashtag.exists?(tag: tag)
              @project.hashtags.create(tag: tag)
            else
              @project.hashtags << Hashtag.find_by(tag: tag)
            end
          end
        end
        if @project.public
          postbot_says("User #{@user.name} created a new project using the model #{@project.model.name}", @project.hashtags)
        end
        format.html { redirect_to user_project_path(current_user, @project) }
        flash['success'] = "Project was successfully created."
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
        format.html { redirect_to @project }
        flash['success'] = "Project was successfully updated."
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
    authorize @project
    @project.destroy
    if(params[:redirect] != "false")
      respond_to do |format|
        format.html { redirect_to projects_url }
        flash['warning'] = "Project was successfully destroyed."
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_project
      @project = Project.find(params[:id])
    end

    def correct_user
      @project = Project.find(params[:project_id])
      redirect_to :back if @project.user != current_user
    end

    def is_project_owner
      @project = Project.find(params[:id])
      redirect_back(fallback_location: projects_url) if @project.user != current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:job, :name, :usertags, :model_id, :public, :revision)
    end

    def job_params
      params.require(:project).permit(:job => [:status , :user_id, :arguments])
    end

    def toggle_public_params
      params.require(:project)
    end

    def config_params
      # Config parameter set
      if params[:config].present?
        cf = params.require(:config).permit!.to_h
      else
        p "Empty parameter set"
        {:config => {}}
      end
    end

end

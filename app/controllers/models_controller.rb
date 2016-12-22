class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy, :download, :reupload]
  #before_action :admin_user, only: [:index, :new]

  # GET /models
  # GET /models.json
  def index
    authorize Model
    @models = policy_scope(Model)
  end

  # GET /models/1
  # GET /models/1.json
  def show
    authorize Model
  end

  # GET /models/new
  def new
    authorize Model
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
    authorize @model
  end

  def register_model
    @model.user = current_user
    if not @model.passed_checks?
      redirect_to :back, notice: 'Error: Model has not passed checks:' + @model.log
    else
      respond_to do |format|
        if @model.save
          @model.initializer
          format.html { return render :show, notice: 'Model was successfully created.' }
          format.json { render :show, status: :created, location: @model }
        else
          format.html { render :new }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def reupload
    #@TODO Deprecated?
    authorize @model
      respond_to do |format|
          format.html { return render :reupload}
      end
  end

  # POST /models
  # POST /models.json
  def create
    authorize Model
    @model = Model.new(model_params)
    if name_is_unique
      register_model
      if !model_params[:usertags].nil?
      # Save all user-supplied hashtags
      usertags = model_params[:usertags].split(/\s*[,;]\s*|\s{1,}/x)

      project_hashtag_format = /^[a-z0-9][a-z0-9]project[0-9]+$/
      model_hashtag_format = /^[a-z0-9][a-z0-9]model[0-9]+$/

      usertags.each do |rawtag|
        tag = rawtag.to_s.downcase.gsub(/#/, '')
        if !(project_hashtag_format.match(tag) or model_hashtag_format.match(tag))
          if !Hashtag.exists?(tag: tag)
            @model.hashtags.create(tag: tag)
          else
            @model.hashtags << Hashtag.find_by(tag: tag)
          end
        end
      end
    end
      postbot_says("User #{@model.user.name} registered a new model with the name #{@model.name}", @model.hashtags)
    else
      redirect_to :back, notice: 'Error: Model name already exists.'
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    authorize @model
    #respond_to do |format|
      if model_params.key?(:source) # In case of reupload
        if !@model.is_zip? model_params[:source].tempfile
          flash[:danger] = "Invalid file type. Please upload a zip with your model."
          redirect_to :back
        else
          @model.update_files(model_params[:source],model_params[:tag]) # Update actual scripts and files
          @model.mainscript[@model.current_revision] = @model.get_main_script
          @model.save
          flash[:success] = "Model has been successfully updated"
          redirect_to @model
        end
      else
        # As of now, only the main script of the latest revision can be changed #TODO
        @model.mainscript[@model.current_revision] = model_params[:mainscript]
        @model.update(model_params.except(:mainscript))
        flash[:success] = "Model has been successfully updated"
        redirect_to @model
      end
  end

  def download
    @model = Model.find(params[:id])
    authorize @model
    send_file @model.provide_source(params[:revision]), :type => 'application/zip', :disposition => 'attachment', :filename => "#{@model.name.gsub(' ', '_')}_#{params[:revision][1..6]}.zip"
  end

def show_logo
    authorize Model
    @model = Model.find(params[:id])
    send_data @model.logo, :type => 'image/png',:disposition => 'inline'

  end
  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    authorize @model
    @model.delete_files
    @model.destroy
    respond_to do |format|
      format.html { redirect_to models_url, notice: 'Model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = Model.find(params[:id])
    end

    def name_is_unique
      !Model.all.map {|x| x.name == @model.name}.compact.any?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      params.require(:model).permit(:name, :source, :mainscript, :description, :help, :tag, :usertags, :doi, :citation)
    end

    #confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

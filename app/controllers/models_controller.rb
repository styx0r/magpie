class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy, :download, :reupload]
  before_action :admin_user, only: [:index, :new]

  # GET /models
  # GET /models.json
  def index
    @models = Model.all
  end

  # GET /models/1
  # GET /models/1.json
  def show
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  def register_model
    @model.user = current_user
    if not @model.passed_checks
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
      respond_to do |format|
          format.html { return render :reupload}
      end
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(model_params)
    if name_is_unique
      register_model
      if !model_params[:usertags].nil?
      # Save all user-supplied hashtags
      usertags = model_params[:usertags].split(/\s*[,;]\s*|\s{1,}/x)

      project_hashtag_format = /^[a-z0-9][a-z0-9]project[0-9]+$/
      model_hashtag_format = /^[a-z0-9][a-z0-9]model[0-9]+$/

      # Add unique project hashtags
      require 'securerandom'
      random_string = SecureRandom.hex(1)
      project_hashtag = random_string+'model'+@model.id.to_s
      @model.hashtags.create(tag: project_hashtag, reserved: true)

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
    respond_to do |format|
      if @model.update(model_params)
        if model_params.key?(:source) # In case of reupload
          @model.update_files(model_params[:source],model_params[:tag]) # Update actual scripts and files
          @model.mainscript[@model.current_revision] = @model.get_main_script
          @model.save
          # Update main script #TODO
        end
        format.html { redirect_to @model, notice: 'Model was successfully updated.' }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  def download
    @model = Model.find(params[:id])
    send_file @model.provide_source(params[:revision]), :type => 'application/zip', :disposition => 'attachment', :filename => "#{@model.name.gsub!(' ', '_')}_#{params[:revision][1..6]}.zip"
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
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

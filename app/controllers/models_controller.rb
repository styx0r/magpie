class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy]
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
    @model.path = "#{Rails.application.config.models_path}#{@model.name}"
    if not @model.passed_checks
      redirect_to :back, notice: 'Error: Model has not passed checks:' + @model.log
    else
      #@model.unzip_source
      #@model.read_content
      revnumber = @model.initialize_git
      p "Created git repo. Latest commit with revision number: #{revnumber}"
      @model.version = revnumber
      respond_to do |format|
        if @model.save
          format.html { return render :show, notice: 'Model was successfully created.' }
          format.json { render :show, status: :created, location: @model }
        else
          format.html { render :new }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(model_params)
    if name_is_unique
      register_model
    else
      redirect_to :back, notice: 'Error: Model name already exists.'
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    respond_to do |format|
      if @model.update(model_params)
        format.html { redirect_to @model, notice: 'Model was successfully updated.' }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:model).permit(:name, :source, :mainscript, :description, :help, :version)
    end

    #confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

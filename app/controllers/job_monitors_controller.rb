class JobMonitorsController < ApplicationController
  before_action :set_job_monitor, only: [:show, :edit, :update, :destroy]

  # GET /job_monitors
  # GET /job_monitors.json
  def index
    @job_monitors = JobMonitor.all
  end

  # GET /job_monitors/1
  # GET /job_monitors/1.json
  def show
  end

  # GET /job_monitors/new
  def new
    @job_monitor = JobMonitor.new
  end

  # GET /job_monitors/1/edit
  def edit
  end

  # POST /job_monitors
  # POST /job_monitors.json
  def create
    @job_monitor = JobMonitor.new(job_monitor_params)

    respond_to do |format|
      if @job_monitor.save
        format.html { redirect_to @job_monitor, notice: 'Job monitor was successfully created.' }
        format.json { render :show, status: :created, location: @job_monitor }
      else
        format.html { render :new }
        format.json { render json: @job_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_monitors/1
  # PATCH/PUT /job_monitors/1.json
  def update
    respond_to do |format|
      if @job_monitor.update(job_monitor_params)
        format.html { redirect_to @job_monitor, notice: 'Job monitor was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_monitor }
      else
        format.html { render :edit }
        format.json { render json: @job_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_monitors/1
  # DELETE /job_monitors/1.json
  def destroy
    @job_monitor.destroy
    respond_to do |format|
      format.html { redirect_to job_monitors_url, notice: 'Job monitor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_monitor
      @job_monitor = JobMonitor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_monitor_params
      params.require(:job_monitor).permit(:job_id, :user)
    end
end

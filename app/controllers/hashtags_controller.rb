class HashtagsController < ApplicationController
  before_action :set_job

  # GET /hashtags/1
  # GET /hashtags/1.json
  def show
  end


end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

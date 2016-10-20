class HashtagsController < ApplicationController
  before_action :set_hashtag

  # GET /hashtags/tag
  # GET /hashtags/tag.json
  def show
  end


end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hashtag
      @hashtag = Hashtag.find_by(tag: params[:tag])
    end

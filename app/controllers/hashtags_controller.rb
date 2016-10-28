class HashtagsController < ApplicationController
  before_action :set_hashtag, only: :show

  def index
    @hashtags = Hashtag.all
  end

  def autocomplete
  hashtags = Hashtag.all.map do |htag|
    {
      tag: htag.tag
    }
  end

  render json: hashtags
end


  # GET /hashtags/tag
  # GET /hashtags/tag.json
  def show
    redirect_to(root_url, :notice => 'Hashtag not found') unless @hashtag
  end


  def create
    @hashtag = Hashtag.new(params)
  end

end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hashtag
      @hashtag = Hashtag.find_by(tag: params[:tag].downcase)
    end

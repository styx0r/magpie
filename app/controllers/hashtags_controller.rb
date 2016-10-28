class HashtagsController < ApplicationController
  before_action :set_hashtag, only: :show

  def index
    @hashtags = Hashtag.all
  end

  def autocomplete
  # Match all hashtags starting with query
  lastword = params[:query].split(' ')[-1]
  if lastword.start_with?('#')
    lastword.gsub!('#','')
  end
  hashtags = Hashtag.where("tag like ?", "#{lastword}%").map do |htag|
    {
      tag: "##{htag.tag}"
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

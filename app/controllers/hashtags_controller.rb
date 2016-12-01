class HashtagsController < ApplicationController
  before_action :set_hashtag, only: :show

  def index
    @hashtags = policy_scope(Hashtag)
  end

  def autocomplete
  authorize Hashtag
  # Match all hashtags starting with query in URL
  query = params[:query]
  if query.blank? # Only whitespace
    render json: []
  else
    hashtags = Hashtag.where("tag like ?", "#{query}%").map do |htag|
    {
      tag: "##{htag.tag}"
    }
  end
  render json: hashtags
end

end


  # GET /hashtags/tag
  # GET /hashtags/tag.json
  def show
    authorize Hashtag
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

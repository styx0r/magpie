class MicropostsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :logged_in_user, only: :destroy
  before_action :correct_user,   only: :destroy

  def create
    authorize Micropost
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      @micropost.extract_hashtags
      @micropost.extract_mentions
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render "dashboard/index"
    end
    for user in current_user.followers
      ActionCable.server.broadcast("microposts_#{user.id}",
        notify: true)
    end
  end


  def destroy
    authorize @micropost
    @micropost.destroy
    flash[:warning] = "Micropost deleted"
    redirect_to request.referrer || root_url
    for user in current_user.followers
      ActionCable.server.broadcast("microposts_#{user.id}",
        notify: true)
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end

class DashboardController < ApplicationController
  skip_after_action :verify_policy_scoped, :only => :index

  def index
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end


  def microposts_feed
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    # rendered without layout in case we are directly on dashboard
    # (without page call of the feed)
    if(!params[:page])
      render :layout => false, file: 'shared/_feed'
    else
      render file: 'shared/_feed'
    end
  end

end

class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    authorize Relationship
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  def destroy
    authorize Relationship
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

end

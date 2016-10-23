class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update, :destroy]
  before_action :admin_user,      only: [:index]
  before_action :can_destroy,     only: [:destroy]

  def destroy
    if @user.guest?
      User.find(params[:id]).destroy
      flash[:success] = "Session data deleted"
      redirect_to root_url
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

  def delete_all_projects
    @user = User.find(params[:user_id])
    @user.projects.destroy_all
    respond_to do |format|
      format.html { redirect_to edit_user_path({:id => @user.id}), notice: 'All projects have been deleted.' }
      format.json { head :no_content }
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    #@user = User.new(user_params)
    if @user.save
      if !@user.guest
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
      else
        session[:user_id] = @user.id
      end
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if user_params[:new_hashtags]
      usertags = user_params[:new_hashtags].split(/\s*[,;]\s*|\s{1,}/x)
      usertags.each do |rawtag|
        tag = rawtag.to_s.downcase.gsub(/#/, '')
        if !Hashtag.exists?(tag: tag)
          @user.hashtags.create(tag: tag)
        else
          @user.hashtags << Hashtag.find_by(tag: tag)
        end
    end
  end

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :identity, :email, :password, :password_confirmation, :guest, :new_hashtags)
    end


    #Before filters
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # User allowed to destroy if he want to destroy his guest account or is admin_user
    def can_destroy
      current_user.admin? || (params[:id] == current_user.id && current_user.guest?)
    end

end

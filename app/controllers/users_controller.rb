class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  #before_action :admin_user,      only: [:index]
  #before_action :can_destroy,     only: [:destroy]

  def destroy
    @user = User.find(params[:id])
    authorize @user
    if current_user.guest?
      @user.destroy
      flash[:success] = "Session data deleted"
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

  def autocomplete
  authorize User
  # Match all users starting with query in URL
  query = params[:query]
  if query.blank? # Only whitespace
    render json: []
  else
    users = User.where("identity like ?", "#{query}%").map do |user|
    {
      tag: "@#{user.identity}",
      name: user.name
    }
  end
  render json: users
end
end

  def hashtag_delete
    session[:return_to] ||= request.referer
    @user = User.find(params[:user_id])
    authorize @user
    @user.hashtags.delete(Hashtag.find_by(tag: params[:tag]))
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      flash[:warning] = "Hashtag ##{params[:tag]} has been removed."
      format.json { head :no_content }
    end
  end

  def hashtag_add
    session[:return_to] ||= request.referer
    @user = User.find(params[:user_id])
    authorize @user
    if !Hashtag.find_by(tag: params[:tag]).nil?
        @user.hashtags << Hashtag.find_by(tag: params[:tag])
    end
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to)}
      format.json { head :no_content }
    end
  end

  def toggle_admin
    session[:return_to] ||= request.referer
    @user = User.find(params[:user_id])
    authorize @user
    @user.update_attribute("admin", !@user.admin)
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: "Changed successfully done!" }
      format.json { head :no_content }
    end
  end

  def toggle_right
    session[:return_to] ||= request.referer
    @user = User.find(params[:user_id])
    authorize @user
    @role = params[:role]
    @user.right.update_attribute(@role, !@user.right[@role])
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: "Changed successfully done!" }
      format.json { head :no_content }
    end
  end

  def delete_all_projects
    authorize User
    @user = User.find(params[:user_id])
    @user.projects.destroy_all
    respond_to do |format|
      format.html { redirect_to edit_user_path({:id => @user.id}) }
      flash[:warning] = "All projects have been deleted."
      format.json { head :no_content }
    end
  end

  def index
    authorize User
    @users = policy_scope(User.paginate(page: params[:page]))
  end

  def show
    skip_authorization
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    skip_authorization
    @user = User.new
  end

  def create
    skip_authorization
    @user = params[:user] ? User.new(user_params) : User.new_guest
    @user.create_right
    if !@user.guest
      @user.right.update_attribute("model_add", true)
      @user.right.update_attribute("user_index", true)
    end
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
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if user_params[:new_hashtags]
      usertags = user_params[:new_hashtags].split(/\s*[,;]\s*|\s{1,}/x)
      usertags.each do |rawtag|
        tag = rawtag.to_s.downcase.gsub(/#/, '')
        if !Hashtag.exists?(tag: tag)
          @ht = @user.hashtags.create(tag: tag)
          if !@ht.valid?
            flash[:danger] = "Hashtag too long or not valid ..."
            redirect_to :back
            return
          end
        else
          if @user.hashtags.find_by(tag: tag).nil?
            @user.hashtags << Hashtag.find_by(tag: tag)
          end
        end
      end
    end

    email_bc = @user.email
    if @user.update_attributes(user_params)
      if(email_bc != @user.email) #user changed email address
        @user.update_attribute("activated", false)
        @user.update_email
        @user.send_activation_email
        session.destroy
        redirect_to root_url
        flash[:success] = "Profile updated."
        flash[:info] = "Please check your (new) email address to reactivate your account."
      else
        flash[:success] = "Profile updated."
        redirect_to edit_user_path(@user)
      end
    else
      render 'edit'
    end
  end

  def following
    authorize User
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    authorize User
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
      @user = User.find(params[:id])
      current_user.admin? || (@user.id == current_user.id && current_user.guest?)
    end

end

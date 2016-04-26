module UserProjectsHelper
  def get_username()
    User.find_by(id: session[:user_id]).name
  end
end

module UserProjectsHelper
  def get_username
    User.find_by(id: session[:user_id]).name
  end

  def list_models
    Dir.glob(Rails.root.join('bin', 'models', '*'))
  end

  def numResultfiles
    @user_project.resultfiles.size
  end


end

module UserProjectsHelper
  def get_username()
    User.find_by(id: session[:user_id]).name
  end

  def list_models()
    # Only find shell scripts
    Dir.glob(Rails.root.join('bin', 'models', '*.sh')) + Dir.glob(Rails.root.join('bin', 'models', '*/*.sh'))
  end

  def numResultfiles
    @user_project.resultfiles.size
  end


end

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

  def get_text_from_file(f)
    #TODO Handle long files (in view?)
    #TODO For now, returns first 500 characters
    cutoff = 500
    file = File.open(f, "rb")
    contents = file.read
    file.close
    if contents.length > cutoff
      contents[0..cutoff] + ' ...'
    else
      contents
    end
  end

  def is_text_file(f)
    #TODO Add better check, using a Ruby module
    f.end_with? '.txt'
  end

  def is_image(f)
    #TODO Add better check, using a Ruby module
    f.end_with? '.gif'
  end

  def get_image_path(num)
    "user_projects/#{@user_project.id}/files/#{num}"
  end


end

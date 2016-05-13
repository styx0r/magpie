module ProjectsHelper

  #TODO Should be superfluous now...
  def get_username()
    User.find_by(id: session[:user_id]).name
  end

  #TODO Should be superfluous now ...
  def userid
    session[:user_id]
  end

  def list_models()
    # Only find shell scripts
    Dir.glob(Rails.root.join('bin', 'models', '*.sh')) + Dir.glob(Rails.root.join('bin', 'models', '*/*.sh'))
  end

  def numResultfiles
    @project.resultfiles.size
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

  #TODO Use method from Christoph
  def is_image(f)
    #TODO Add better check, using a Ruby module
    f.end_with? '.gif'
  end

  #TODO Could be wrong, should be something with user_id
  def get_image_path(num)
    "#{user_id}/projects/#{@project.id}/files/#{num}"
  end
end

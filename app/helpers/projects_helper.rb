module ProjectsHelper
  require 'ruby-filemagic'
  require 'mime/types'

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
    Dir.glob(Rails.root.join('bin', 'models', '*/*.sh'))
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

  def filetype(f)
    fm = FileMagic.new(FileMagic::MAGIC_MIME)
    mime_type = fm.file(f)
    puts "MIMETYPE::::" + mime_type
    if mime_type.start_with? "inode/x-empty"
      filetype = 'empty'
    else
      filetype = MIME::Types[mime_type][0].extensions[0]
    end
  end

  def is_text_file(f)
    supported_types = ['txt']
    supported_types.include? filetype(f)
  end

  def is_image(f)
    supported_types = ['gif', 'png', 'pdf', 'jpeg']
    supported_types.include? filetype(f)
  end

  def is_pdf(f)
    filetype(f) == 'pdf'
  end

  #TODO Simplify path
  def get_image_path(num)
    "#{current_user.id.to_s}/projects/#{@project.id}/files/#{num}"
  end
end

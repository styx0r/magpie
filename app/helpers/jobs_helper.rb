module JobsHelper

  #TODO Simplify path
  def get_image_path jobid, imageid
    "#{jobid}/files/#{imageid}"
  end

  #TODO Move into /lib
  def get_text_from_file(f)
    #TODO Handle long files (in view?)
    #TODO For now, returns first 500 characters
    cutoff = 100000
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

  def extract_data(fil, plottype)
    # Extract data from files with data for D3 plots
    if plottype == 'barplot'
      data = Array.new()
      open(fil, "r") do |f|
            f.each_line do |line|
              data.push(line.strip.to_f)
                      end
    end
  end
      return data
  end

  def iplot?(f)
    ['.iplot'].include? File.extname(f)
  end

  def is_text_file(f)
    supported_types = ['txt']
    supported_types.include? filetype(f)
  end

  def is_image(f)
    supported_types = ['gif', 'png', 'jpeg']
    supported_types.include? filetype(f)
  end

  def is_pdf(f)
    filetype(f) == 'pdf'
  end

end

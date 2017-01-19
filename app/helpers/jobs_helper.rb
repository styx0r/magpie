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
      return 'empty'
    else
      return mime_type
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
    supported_types = ['text/plain']
    mt = filetype(f)
    supported_types.any? { |mime| mt.include?(mime) }
  end

  def is_image(f)
    supported_types = ['image/gif', 'image/png', 'image/jpeg']
    mt = filetype(f)
    supported_types.any? { |mime| mt.include?(mime) }
  end

  def is_pdf(f)
    supported_types = ['application/pdf']
    mt = filetype(f)
    supported_types.any? { |mime| mt.include?(mime) }
  end

  def is_xml(f)
    supported_types = ['application/xml', 'text/xml']
    mt = filetype(f)
    supported_types.any? { |mime| mt.include?(mime) }
  end

end

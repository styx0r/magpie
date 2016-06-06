class Model < ActiveRecord::Base
  belongs_to :user
  mount_uploader :source, ModelUploader

  def get_main_script
    files = Dir.entries(self.path)
    shell_files = files.select do |file|
      file.end_with?('.sh')
    end
    shell_files.include?('main.sh') ? 'main.sh' :  shell_files[0]
  end

  def read_content
    self.mainscript = get_main_script

    #TODO Get description
    #TODO Get help

    return true
  end

  def unzip_source
    require 'zip'
    FileUtils.mkdir_p(self.path)
    Zip::File.open(self.source.file.file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(self.path, File.basename(f.name))
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end

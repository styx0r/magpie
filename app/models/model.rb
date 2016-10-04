class Model < ActiveRecord::Base
  belongs_to :user
  mount_uploader :source, ModelUploader
  attr_accessor :tmp_path

  def delete_files
    # Delete files (before model is destroyed)
    require 'fileutils'
    FileUtils.remove_dir self.path, true
  end

  def passed_checks
    #TODO Implement checks
    true
  end

  def initializer
    # Initialize git repository for model and saves revision number
    FileUtils.mkdir_p(self.path)
    require 'tmpdir'
    self.tmp_path = Dir.mktmpdir
    p "Temporary folder for unzipping at #{self.tmp_path}"
    system("cd #{self.path}; git init --bare; cd #{self.tmp_path}; git clone #{self.path} #{self.tmp_path}")
    self.unzip_source
    self.read_content
    system("cd #{self.tmp_path}; git tag -a initial -m 'Initial version'; git add -A; git commit -m 'Initial commit for model #{self.name}'; git push origin master --tags;")
  end

  def get_main_script
    files = Dir.entries(self.tmp_path)
    shell_files = files.select do |file|
      file.end_with?('.sh')
    end
    shell_files.include?('main.sh') ? 'main.sh' :  shell_files[0]
  end

  def versions
    output, status = Open3.capture2("cd #{self.path}; git tag;")
    output.split
  end

  def read_content
    self.mainscript = get_main_script

    #TODO Get description
    #TODO Get help

    return true
  end

  def unzip_source
    require 'zip'
    Zip::File.open(self.source.file.file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(self.tmp_path, File.basename(f.name))
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end

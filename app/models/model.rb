class Model < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :hashtags, -> { distinct }, through: :taggings
  has_many :projects, dependent: :destroy
  mount_uploader :source, ModelUploader
  attr_accessor :tmp_path, :tag, :usertags
  validates :name, presence: true, length: { maximum: 100 }
  serialize :mainscript

  def delete_files
    # Delete files (before model is destroyed)
    require 'fileutils'
    FileUtils.remove_dir self.path, true
  end

  def passed_checks?
    # TODO: much more checks, most importatnly: check whether zip is empty,
    # check whether bash script exists.
    if self.source.file.nil?
      return false
    else
      return (self.is_zip? self.source.file.file) || (self.is_xml? self.source.file.file)
    end
  end

  def is_zip? f
    fm = FileMagic.new(FileMagic::MAGIC_MIME)
    mt = fm.file(f)
    supported_types = ['application/zip']
    return supported_types.any? { |mime| mt.include?(mime) }
  end

  def is_xml? f
    fm = FileMagic.new(FileMagic::MAGIC_MIME)
    mt = fm.file(f)
    supported_types = ['application/xml', 'text/xml']
    return supported_types.any? { |mime| mt.include?(mime) }
  end

  def initializer
    # Initialize git repository for model and saves revision number
    self.path = "#{Rails.application.config.models_path}#{self.id.to_s}"
    system("rm -rf #{self.path}")
    FileUtils.mkdir_p(self.path)
    require 'tmpdir'
    self.tmp_path = Dir.mktmpdir
    p "Temporary folder for unzipping at #{self.tmp_path}"
    system("cd #{self.path}; git init --bare;")
    if self.is_xml? self.source.file.file # Assuming it is SBML
      system("cd #{self.tmp_path}; git clone #{self.path} #{self.tmp_path};")
      self.unzip_source("#{Rails.application.config.root}/test/zip/sbmlShell.zip", self.tmp_path)
      system("cp #{Rails.application.config.root}/test/seedextra/createSBMLConfig.py #{self.tmp_path}")
      system("cp #{self.source.file.file} #{self.tmp_path}/sbml.xml")

      # work arround due to docker bug
      FileUtils.mkdir_p(self.path+"/create")
      system("cp #{self.tmp_path}/* #{self.path}/create")

      container = Docker::Container.create('Image' => 'magpie:default',
                                           'Tty' => true,
                                           'Binds' => ["#{self.path}/create:/root/job:rw"])
      container.start()

      # 7200 corresponds to the maximum computation time per job
      # 2097152 defines the maximum virtual memory, which can be used by one particular process (2048MB)
      c_out = container.exec(["/bin/bash", "-c", "cd /root/job; python createSBMLConfig.py sbml.xml"],
                             wait: Rails.application.config.docker_timeout)

      container.stop
      container.remove
      system("cp #{self.path}/create/*.config #{self.tmp_path}")
      system("rm -fR #{self.path}/create")
      system("cd #{self.tmp_path}; rm createSBMLConfig.py")
    elsif
      self.unzip_source(self.source.file.file, self.tmp_path)
      out = self.check_zip self.tmp_path
      if out != 0
        return out
      end
      # move all model data into root directory of sh file
      self.move_shell_dir_to_root self.tmp_path, false
    end

    system("cd #{self.tmp_path}; git add -A; git commit -m 'Initial commit for model #{self.name}'; git tag -a initial -m 'Initial version'; git push origin master --tags;")

    self.mainscript = Hash[self.current_revision.strip, get_main_script]
    self.set_default_logo
    self.assign_unique_hashtag
    self.save
    return 0
  end

  def move_shell_dir_to_root path, update
    tmp_path = Dir.mktmpdir
    system("cd #{tmp_path}; git clone #{self.path} #{tmp_path};")
    if update
      system("cd #{tmp_path}; git rm -r *")
    end

    files = Dir[self.tmp_path+"/**/*"]#Dir.entries(self.tmp_path)
    sh_files = files.select { |s| (File.basename s).end_with?('.sh') & !(File.basename s).start_with?('.sh') } # if no .sh script is available
    sh_file_main = sh_files.index { |s| (File.basename s) == "main.sh" }

    if sh_file_main.nil?
      sh_file = sh_files.at(0)
    else
      sh_file = sh_files.at(sh_file_main)
    end

    FileUtils.cp_r (Dir.glob ((File.dirname sh_file)+"/{*}")), tmp_path
    FileUtils.remove_dir path
    FileUtils.mv tmp_path, path
  end

  def check_zip path
    # check whether sh script can be found
    files = Dir.glob self.tmp_path+"{/*,/**/*}" #Dir.entries(self.tmp_path)
    if(files.none? { |s| (File.basename s).end_with?('.sh') & !(File.basename s).start_with?('.sh') }) # if no .sh script is available
      return 1
    end
    return 0
  end

  def assign_unique_hashtag
    # Add unique project hashtags
    require 'securerandom'
    random_string = SecureRandom.hex(1)
    project_hashtag = random_string+'model'+self.id.to_s
    self.hashtags.create(tag: project_hashtag, reserved: true)
  end

  def set_default_logo
    require 'mini_magick'
    if self.logo.nil?
      self.logo = MiniMagick::Image.open("#{Rails.application.config.root}/test/zip/logos/magpie.png").to_blob
    end
  end

  def update_files(src,newtag)
    FileUtils.mkdir_p(self.path)
    require 'tmpdir'
    self.tmp_path = Dir.mktmpdir
    p "Temporary folder for unzipping at #{self.tmp_path}"
    unzip_source(src.tempfile, self.tmp_path)
    out = self.check_zip self.tmp_path
    if out != 0
      return out
    end

    # move all model data into root directory of sh file
    self.move_shell_dir_to_root self.tmp_path, true

    system("cd #{self.tmp_path}; git add -A")

    # Check if anything has changed
    output, status = Open3.capture2("cd #{self.tmp_path}; git status --porcelain")
    if output.empty?
      return nil
    end

    system("cd #{self.tmp_path};git commit -m 'User uploaded new version with tag #{newtag}'")
    if !newtag.empty?
      system("cd #{self.tmp_path};git tag -a '#{newtag.gsub(/[^0-9a-z.,]/i, '').gsub(/[.,]*$/, '')}' -m 'User uploaded new version'; git push origin master --tags")
    end
    return 0
  end

  def current_revision
    revision, status = Open3.capture2("cd #{self.path}; git rev-parse HEAD;")
    return revision.strip
  end

  def get_main_script
    files = Dir.entries(self.tmp_path)
    shell_files = files.select do |file|
      file.end_with?('.sh')
    end
    shell_files.include?('main.sh') ? 'main.sh' :  shell_files[0]
  end

  def versions
    # Chronogically (reversed) ordered output of versions
    output, status = Open3.capture2("cd #{self.path}; git for-each-ref --sort=taggerdate --format '%(tag)' refs/tags;")
    output.split.reverse
  end

  def tag_to_revision tag
    require 'open3'
    #output, status = Open3.capture2("cd #{self.path}; git rev-parse --verify #{tag}")
    output, status = Open3.capture2("cd #{self.path}; git rev-list -n 1 #{tag}")
    output.strip
  end

  def provide_source revision
    require 'tmpdir'
    require 'zip'
    tmp_path = Dir.mktmpdir
    system("git clone #{self.path} #{tmp_path}")
    zipfile = "#{tmp_path}/#{self.id}_#{revision}.zip"
    system("cd #{tmp_path}; git reset --hard #{revision};zip -r #{zipfile} . -x *.git*")
    zipfile
    end

  def unzip_source(spath,opath)
    require 'zip'
    Zip::File.open(spath) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(opath, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end

class Model < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :hashtags, -> { distinct }, through: :taggings
  mount_uploader :source, ModelUploader
  attr_accessor :tmp_path, :tag, :usertags
  validates :name, presence: true, length: { maximum: 30 }
  serialize :mainscript

  def delete_files
    # Delete files (before model is destroyed)
    require 'fileutils'
    FileUtils.remove_dir self.path, true
  end

  def passed_checks?
    return self.is_zip? self.source.file.file
  end

  def is_zip? sourcefile
    zip = Zip::File.open(sourcefile)
    true
  rescue StandardError
    false
  ensure
    zip.close if zip
  end

  def initializer
    # Initialize git repository for model and saves revision number
    self.path = "#{Rails.application.config.models_path}#{self.id.to_s}"
    system("rm -rf #{self.path}")
    FileUtils.mkdir_p(self.path)
    require 'tmpdir'
    self.tmp_path = Dir.mktmpdir
    p "Temporary folder for unzipping at #{self.tmp_path}"
    system("cd #{self.path}; git init --bare; cd #{self.tmp_path}; git clone #{self.path} #{self.tmp_path}")
    self.unzip_source(self.source.file.file, self.tmp_path)
    system("cd #{self.tmp_path}; git add -A; git commit -m 'Initial commit for model #{self.name}'; git tag -a initial -m 'Initial version'; git push origin master --tags;")

    self.mainscript = Hash[self.current_revision.strip, get_main_script]
    self.set_default_logo
    self.assign_unique_hashtag
    self.save
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
    system("git clone #{self.path} #{self.tmp_path}")
    system("cd #{self.tmp_path}; git rm *")
    #unzip_source(self.source.file.file, self.tmp_path)
    unzip_source(src.tempfile, self.tmp_path)
    system("cd #{self.tmp_path}; git add -A")
    if !newtag.empty?
      system("cd #{self.tmp_path};git tag -a '#{newtag.gsub(/[^0-9a-z.,]/i, '').gsub(/[.,]*$/, '')}' -m 'User uploaded new version'")
    end
    system("cd #{self.tmp_path};git commit -m 'User uploaded new version'; git push origin master --tags")
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

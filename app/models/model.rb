class Model < ActiveRecord::Base
  belongs_to :user
  mount_uploader :source, ModelUploader

  def read_content
    return true
  end

  def unzip_source
    require 'zip'
    FileUtils.mkdir_p(self.path)
    Zip::File.open(self.source.file.file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(self.path, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end

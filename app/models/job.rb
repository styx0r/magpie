class Job < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  serialize :output  # output is a hash, so serialize it
  serialize :resultfiles
  serialize :arguments

  def zip_result_files
    ## Now, create a zipped archive of all resultfiles, if there are any
    require 'zip'
    zip_results = "#{self.directory}/all-resultfiles-#{self.project.name}-#{self.id.to_s}.zip"
    zip_config = "#{self.directory}/config-#{self.project.name}-#{self.id.to_s}.zip"
    Zip::File.open(zip_results, Zip::File::CREATE) do |zipfile|
      self.resultfiles.each do |resultfile|
        zipfile.add(File.basename(resultfile), resultfile)
      end
    end
    configfiles = Dir.glob(self.directory + "/*.{config,iplot}")
    Zip::File.open(zip_config, Zip::File::CREATE) do |zipfile|
      configfiles.each do |configfile|
        zipfile.add(File.basename(configfile), configfile)
      end
    end
  end

end

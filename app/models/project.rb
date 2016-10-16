class Project < ActiveRecord::Base
  belongs_to :user
  has_many :jobs, dependent: :destroy
  belongs_to :model
  accepts_nested_attributes_for :jobs, :allow_destroy => true

  def tag_to_revision tag
    require 'open3'
    output, status = Open3.capture2("cd #{self.model.path}; git rev-parse --verify #{tag}")
    output.strip
  end

  def tag
    require 'open3'
    output, status = Open3.capture2("cd #{self.model.path}; git tag --points-at #{self.revision}")
    if !output.strip.blank?
      output.strip
    else
      "untagged, revision #{self.revision}"
    end
  end

end

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :hashtags, -> { distinct }, through: :taggings
  has_many :jobs, dependent: :destroy
  belongs_to :model
  attr_accessor :usertags
  validates :name, presence: true, length: { maximum: 100 }
  after_create :check_guest
  accepts_nested_attributes_for :jobs, :allow_destroy => true


  def tag_to_revision tag
    require 'open3'
    output, status = Open3.capture2("cd #{self.model.path}; git rev-list -n 1 #{tag}")
    output.strip
  end

  def assign_unique_hashtag
    # Add unique project hashtags
    require 'securerandom'
    random_string = SecureRandom.hex(1)
    project_hashtag = random_string+'project'+self.id.to_s
    self.hashtags.create(tag: project_hashtag, reserved: true)
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

  def check_guest
    if self.user.guest
      self.public = false
      self.save
    end
  end


end

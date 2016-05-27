class Job < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  serialize :output  # output is a hash, so serialize it
  serialize :resultfiles
  serialize :arguments
end

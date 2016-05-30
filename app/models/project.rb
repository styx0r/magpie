class Project < ActiveRecord::Base
  belongs_to :user
  has_many :jobs
  belongs_to :model
  accepts_nested_attributes_for :jobs, :allow_destroy => true
end

class Tagging < ApplicationRecord
  belongs_to :hashtag
  belongs_to :micropost
  belongs_to :project
  belongs_to :model
  belongs_to :user
end

class Hashtag < ActiveRecord::Base
  has_many :projects, through: :taggings
  has_many :models, through: :taggings
  has_many :microposts, through: :taggings
  has_many :users, through: :taggings
  has_many :taggings
end

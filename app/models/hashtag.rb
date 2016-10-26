class Hashtag < ActiveRecord::Base
  has_many :projects, through: :taggings
  has_many :models, through: :taggings
  has_many :microposts, through: :taggings
  has_many :users, through: :taggings
  has_many :taggings
  validates :tag, presence: true, :format => { with: /\A(?=.*[a-z])[a-z\d]+\Z/i }, length: { maximum: 50}
  validate :tag_not_reserved_keyword
  before_save :downcase_tag

  def downcase_tag
    self.tag.downcase!
  end

  def tag_not_reserved_keyword
    # Make sure tag is not in reserved keywords
    reserved = ["new", "edit", "create"]
    if reserved.include? self.tag.downcase
      errors.add(:field, 'error message')
    end
  end


end

class Hashtag < ActiveRecord::Base
  has_many :projects, through: :taggings
  has_many :models, through: :taggings
  has_many :microposts, through: :taggings
  has_many :users, through: :taggings
  has_many :taggings
  validates :tag, presence: true, :format => { with: /\A(?=.*[a-z\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df])[a-z\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df\d]+\Z/i }, length: { maximum: 50}
  #validates :tag, presence: true, :format => { with: /\A(?=.*[a-z])[a-z\d]+\Z/i }, length: { maximum: 50}
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

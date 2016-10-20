class Micropost < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  belongs_to :user
  has_many :taggings
  has_many :hashtags, through: :taggings
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  def formatted_content
    fstring = self.content
    fstring.gsub!(/#\w+/) do |tag|
      tag.sub!(/^#/, '')
      if Hashtag.exists?(tag: tag)
        link_to(raw("<font color='blue'>##{tag}</font>"), Rails.application.routes.url_helpers.hashtag_path(tag))
      else
        "##{tag}"
      end
    end
    fstring.gsub!(/@\w+/) do |user|
    user.sub!(/^@/, '')
    if User.exists?(identity: user)
      link_to(raw("<font color='red'>@#{user}</font>"), Rails.application.routes.url_helpers.user_path(User.find_by(identity: user)))
    else
      "@#{user}"
    end
    end
    fstring.html_safe
  end

  def hashtag_mentions
    self.content.scan(/#\w+/)
  end

  def user_mentions
    self.content.scan(/@\w+/)
  end

  def extract_hashtags
    self.hashtag_mentions.each do |tag|
      tag.sub!(/^#/, '')
      if Hashtag.exists?(tag: tag)
        self.hashtags << Hashtag.find_by(tag: tag)
      else
        self.hashtags.create(tag: tag)
      end
  end
end

end



private

  #Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

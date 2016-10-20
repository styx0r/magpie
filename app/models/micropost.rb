class Micropost < ActiveRecord::Base
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
    fstring.gsub!(/#\w+/) do |tag| "<font color='blue'>#{tag}</font>" end
    fstring.gsub!(/@\w+/) do |tag| "<font color='red'>#{tag}</font>" end
    fstring.html_safe
  end

end



private

  #Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

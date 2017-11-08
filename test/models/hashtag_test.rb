require 'test_helper'

class HashtagTest < ActiveSupport::TestCase

  def setup
    @user = users(:user)
    @user.hashtags.create(tag: "awesome")
    @hashtag = @user.hashtags.last
  end

  test "hashtag validity?" do
    assert @hashtag.valid?
  end

  test "valid tag present?" do
    @hashtag.tag = "  "
    assert_not @hashtag.valid?
    @hashtag.tag = ""
    assert_not @hashtag.valid?
    @hashtag.tag = "#"
    assert_not @hashtag.valid?
  end

  test "tag not too long?" do
    @hashtag.tag = "a" * 500
    assert_not @hashtag.valid?
  end

  test "hashtags in user should decrease if hashtag is destroyed" do
    assert_difference "@user.hashtags.count", -1 do
      @hashtag.destroy
    end
  end


end

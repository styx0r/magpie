require 'test_helper'

class HashtagPolicyTest < PolicyAssertions::Test

  def test_show
    refute_permit nil, Hashtag
    assert_permit users(:user), Hashtag
  end

  def test_create
    refute_permit nil, Hashtag
    refute_permit users(:user), Hashtag
  end

  def test_update
    refute_permit nil, Hashtag
    refute_permit users(:user), Hashtag
  end

  def test_destroy
    refute_permit nil, Hashtag
    refute_permit users(:user), Hashtag
  end
end

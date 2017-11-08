require 'test_helper'

class MicropostPolicyTest < PolicyAssertions::Test

  def test_show
  end

  def test_create
    refute_permit nil, Micropost
    assert_permit users(:user), Micropost
  end

  def test_update
    refute_permit nil, Micropost
    refute_permit users(:user), Micropost
  end

  def test_destroy
    refute_permit nil, Micropost
    refute_permit users(:admin), microposts(:orange)
    assert_permit users(:user), microposts(:orange)
  end
end

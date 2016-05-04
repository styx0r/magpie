require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:christoph)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id present?" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content present?" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  test "content not longer than 140 characters?" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end

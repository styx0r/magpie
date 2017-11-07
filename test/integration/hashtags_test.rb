require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
  end

  test "if micropost is created, a new hashtag should be added to the hashtags" do
    log_in_as(@user, password: "password_user")
    assert_difference('Hashtag.count', 1) do
      post microposts_path, params: { micropost: { content: "this is a #creepy new hashtag!"} }
    end
  end

  test "if micropost is created, an existing hashtag should not be added to the hashtags" do
    log_in_as(@user, password: "password_user")
    assert_no_difference 'Hashtag.count' do
      post microposts_path, params: { micropost: { content: "this is a #sleepy new hashtag!"} }
    end
  end

end

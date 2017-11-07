require 'test_helper'

class HashtagsControllerTest < ActionController::TestCase

  def setup
    @user = users(:user)
  end

  test "successfull see hashtags, if logged in" do
    log_in_as(@user)
    get :index
    assert flash.empty?
    assert_response :success
  end

  test "redirect to index when not logged in" do
    get :index
    assert !flash.empty?
    assert_redirected_to root_url
  end

  test "redirect back if there isn't the corresponding hashtag" do
    log_in_as(@user)
    request.env["HTTP_REFERER"] = "/users"
    get :show, params: { tag: "not_existing" }
    assert_not flash.empty?
    assert_redirected_to "/users"
  end

  test "show the hashtag if it is existing and user is logged in" do
    log_in_as(@user)
    get :show, params: { tag: "sleepy" }
    assert flash.empty?
    assert_response :success
  end  

end

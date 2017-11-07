require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should get micropost feed, only if logged_in" do
    get :microposts_feed
    assert_not flash.empty?
    assert_response :found
    assert_redirected_to root_url
    @user = users(:user)
    log_in_as(@user)
    get :microposts_feed
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end

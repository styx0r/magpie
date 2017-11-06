require 'test_helper'

class StaticControllerTest < ActionController::TestCase

  setup do
    @user = users(:tutorialbot)
  end

  test "should get about independent whether logged in or not" do
    get :about
    assert_response :success
    log_in_as(@user)
    get :about
    assert_response :success
  end

  test "should NOT get help (not logged in)" do
    get :help
    assert !flash.empty?
    assert_redirected_to root_url
  end

  test "should get help" do
    log_in_as(@user)
    get :help
    assert_response :success
  end

end

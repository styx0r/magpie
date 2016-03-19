require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get new-job" do
    get :new-job
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

end

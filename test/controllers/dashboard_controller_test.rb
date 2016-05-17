require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should get new-job" do
    #get :new_job
    #assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end

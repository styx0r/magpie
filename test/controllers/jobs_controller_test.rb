require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    request.env["HTTP_REFERER"] = "/"
    @job = jobs(:job_1)
    @tutorialbot = users(:tutorialbot)
    @other_user = users(:other_user)
  end

  # new/create job is done via project

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should show job" do
    log_in_as(@tutorialbot)
    get :show, params: { id: @job }
    assert_response :success
  end

  test "should not show the job, because of ownership" do
    log_in_as(@other_user)
    get :show, params: { id: @job }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should get redirect to root url, no edit of jobs allowed" do
    log_in_as(@tutorialbot)
    get :edit, params: { id: @job }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # updates are only made by the magpie itself, since it is changes the status
  # after finishing / aborting a job

  test "should destroy job" do
    log_in_as(@tutorialbot)
    assert_difference('Job.count', -1) do
      delete :destroy, params: { id: @job }
    end
    assert_redirected_to root_path
  end

  test "should not destroy job due to wrong ownership" do
    log_in_as(@other_user)
    assert_no_difference('Job.count') do
      delete :destroy, params: { id: @job }
    end
    assert_redirected_to root_path
  end

end

require 'test_helper'

class JobMonitorsControllerTest < ActionController::TestCase
  setup do
    @job_monitor = job_monitors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_monitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_monitor" do
    assert_difference('JobMonitor.count') do
      post :create, job_monitor: { job_id: @job_monitor.job_id, user: @job_monitor.user }
    end

    assert_redirected_to job_monitor_path(assigns(:job_monitor))
  end

  test "should show job_monitor" do
    get :show, id: @job_monitor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_monitor
    assert_response :success
  end

  test "should update job_monitor" do
    patch :update, id: @job_monitor, job_monitor: { job_id: @job_monitor.job_id, user: @job_monitor.user }
    assert_redirected_to job_monitor_path(assigns(:job_monitor))
  end

  test "should destroy job_monitor" do
    assert_difference('JobMonitor.count', -1) do
      delete :destroy, id: @job_monitor
    end

    assert_redirected_to job_monitors_path
  end
end

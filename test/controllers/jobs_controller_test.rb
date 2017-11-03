require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:simple_project)
    @model = models(:simple_model)
    @job = jobs(:finished)

    @user = users(:nonadmin)

    @project.user_id = @user.id
    @project.model_id = @model.id
    @job.user_id = @user.id

    @other_user = users(:nonadmin2)
  end

  test "should get new" do
    log_in_as(@user)
    get :new
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { status: @job.status }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, params: { id: @job }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @job }
    assert_response :success
  end

  test "should update job" do
    patch :update, params: { id: @job }, job: { status: @job.status }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, params: { id: @job }
    end

    assert_redirected_to jobs_path
  end
end

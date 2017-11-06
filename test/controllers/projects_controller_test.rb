require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:project_1)
    @user = users(:tutorialbot)
  end

  test "should NOT get index (not logged in)" do
    get :index
    assert !flash.empty?
    assert_redirected_to root_url
  end

  test "should get index" do
    log_in_as(@user)
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    log_in_as(@user)
    get :new
    assert_response :success
  end

  test "should NOT get new (not logged in)" do
    get :new
    assert !flash.empty?
    assert_redirected_to root_url
  end

  # a new project needs to have job input data, since the first job is
  # created already

  test "should NOT show project (not logged in)" do
    get :show, params: { id: @project }
    assert !flash.empty?
    assert_redirected_to root_url
  end

  test "should show project" do
    log_in_as(@user)
    get :show, params: { id: @project }
    assert_response :success
  end

  test "should NOT get edit due to invalid route" do
    log_in_as(@user)
    get :edit, params: { id: @project }
    assert !flash.empty?
    assert_redirected_to root_url
  end

  test "should NOT destroy project (not logged in)" do
    assert_difference('Project.count', 0) do
      delete :destroy, params: { id: @project }
    end
    assert_redirected_to projects_path
  end

  test "should destroy project" do
    log_in_as(@user)
    assert_difference('Project.count', -1) do
      delete :destroy, params: { id: @project }
    end

    assert_redirected_to projects_path
  end
end

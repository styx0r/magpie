require 'test_helper'

class ModelsControllerTest < ActionController::TestCase
  setup do
    request.env["HTTP_REFERER"] = ""
    @model = models(:model_1)
    @model_delete = models(:model_delete)
    log_in_as(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #test "should create model" do
  #  assert_difference('Model.count') do
  #    post :create, params: { model: { mainscript: @model.mainscript, name: @model.name, path: @model.path } }
  #  end
  #  assert_redirected_to model_path(assigns(:model))
  #end

  test "should show model" do
    get :show, params: { id: @model }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @model }
    assert_response :success
  end

  test "should update model" do
    patch :update, params: { id: @model, model: { mainscript: @model.mainscript, name: @model.name, path: @model.path } }
    assert_redirected_to model_path(assigns(:model))
  end

  test "should destroy model" do
    assert_difference('Model.count', -1) do
      delete :destroy, params: { id: @model_delete }
    end

    assert_redirected_to models_path
  end
end

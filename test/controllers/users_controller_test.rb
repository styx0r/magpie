require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user.create_right
    @other_user = users(:other_user)
    @other_user.create_right
  end

  test "redirect index when not logged in?" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "redirect edit when not logged in?" do
    get :edit, params: { id: @user }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect update when not logged in?" do
    patch :update, params: { id: @user }, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect edit when logged in as wrong user?" do
    log_in_as(@other_user)
    get :edit, params: { id: @user }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "redirect update when logged in as wrong user?" do
    log_in_as(@other_user)
    patch :update, params: { id: @user }, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "redirect destroy when not logged in?" do
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: @user }
    end
    assert_redirected_to login_url
  end

  test "redirect destroy when logged in as a non-admin?" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: @other_user }
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, params: { id: @user }
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, params: { id: @user }
    assert_redirected_to login_url
  end

end

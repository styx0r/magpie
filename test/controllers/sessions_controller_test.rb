require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = users(:user)
  end

  test "should not get new because of wrong email or password" do
    # wrong email
    post :create, params: { session: { email: @user.email+"wrong",
                                       password: "password_user" } }
    assert_not flash.empty?
    assert flash[:danger] == "Invalid email/password combination"
    assert_response :success

    #wrong password
    post :create, params: { session: { email: @user.email,
                                       password: "password_user2" } }
    assert_not flash.empty?
    assert flash[:danger] == "Invalid email/password combination"
    assert_response :success
  end

  test "should get new with correct login and should be redirected to home_url" do
    post :create, params: { session: { email: @user.email,
                                       password: "password_user" } }
    assert flash.empty?
    assert_redirected_to home_url
  end

end

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
      @user = users(:user)
  end

  test "unsuccessful edit" do
    log_in_as(@user, password: "password_user")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                      email: "foo@invalid",
                                      password:              "foo",
                                      password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user, password: "password_user")
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user, password: "password_user")
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "successful edit without email change" do
    log_in_as(@user, password: "password_user")
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = @user.email
    patch user_path(@user), params: { user: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to edit_user_path(@user)
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding without email change" do
    get edit_user_path(@user)
    log_in_as(@user, password: "password_user")
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = @user.email
    patch user_path(@user), params: { user: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to edit_user_path(@user)
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end

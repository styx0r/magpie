require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User",
                     email: "user@example.com",
                     password: "pwSecure", password_confirmation: "pwSecure")
  end

  test "user validity?" do
    assert@user.valid?
  end

  test "name present?" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email present?" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name too long?" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email too long?" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email valid?" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} is valid"
    end
  end

  test "email not valid?" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com test@test..de]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} is not valid"
    end
  end

  test "email is unique?" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?, "#{duplicate_user.email} already exists!"
  end

  test "email is saved in downcase?" do
    capitalString = "Capital@Uppercase.De"
    @user.email = capitalString
    @user.save
    @user.reload
    assert_equal @user.email, capitalString.downcase
  end

  test "password present?" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password minimum length fulfilled?" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end

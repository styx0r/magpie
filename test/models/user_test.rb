require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "user validity?" do
    assert@user.valid?
  end

  test "name present?" do
    @user.name = "     "
    assert_not @user.valid?
  end

end

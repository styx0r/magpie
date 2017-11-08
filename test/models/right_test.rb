require 'test_helper'

class RightTest < ActiveSupport::TestCase

  def setup
    @user = users(:admin)
    @right = rights(:right_1)
  end

  test "if user is deleted, the corresponding rights should be deleted as well" do
    assert_difference "Right.count", -1 do
      @user.destroy
    end
  end

end

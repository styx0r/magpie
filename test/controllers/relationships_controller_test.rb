require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  setup do
    request.env["HTTP_REFERER"] = "old_loc"
    @user = users(:tutorialbot)
  end

  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "following should increase number of relationships by one" do
    log_in_as(@user)
    assert_difference('Relationship.count', 1) do
      post :create, params: { followed_id: users(:archer) }
    end
    assert_redirected_to "old_loc"
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, params: { id: relationships(:one) }
    end
    assert_redirected_to login_url
  end
end

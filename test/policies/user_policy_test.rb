require 'test_helper'

class UserPolicyTest < PolicyAssertions::Test

  def test_delete_all_projects
    refute_permit nil, User
    assert_permit users(:user), User
    assert_permit users(:tutorialbot), User
    assert_permit users(:admin), User
  end

  def test_hashtag_add
    refute_permit nil, User
    assert_permit users(:user), users(:user)
    refute_permit users(:tutorialbot), users(:user)
    refute_permit users(:admin), users(:user)
  end

  def test_toggle_admin
    refute_permit nil, User
    refute_permit users(:user), users(:user)
    refute_permit users(:tutorialbot), users(:user)
    refute_permit users(:admin), users(:admin)
    assert_permit users(:admin), users(:user)
  end

  def test_toggle_right
    refute_permit nil, User
    refute_permit users(:user), users(:user)
    refute_permit users(:tutorialbot), users(:user)
    refute_permit users(:admin), users(:admin)
    assert_permit users(:admin), users(:user)
  end

  def test_hashtag_delete
    refute_permit nil, User
    assert_permit users(:user), users(:user)
    refute_permit users(:tutorialbot), users(:user)
    refute_permit users(:admin), users(:user)
  end

  def test_autocomplete
    refute_permit nil, User
    assert_permit users(:user), User
    assert_permit users(:tutorialbot), User
    assert_permit users(:admin), User
  end

  def test_destroy
    refute_permit nil, User
    assert_permit users(:admin), users(:user)
    refute_permit users(:user), users(:tutorialbot)
    users(:user).right.user_delete = true
    assert_permit users(:user), users(:tutorialbot)
    assert_permit users(:admin), users(:admin)
  end

  def test_edit
    refute_permit nil, User
    refute_permit users(:admin), users(:user)
    refute_permit users(:user), users(:tutorialbot)
    assert_permit users(:admin), users(:admin)
    assert_permit users(:user), users(:user)
    assert_permit users(:tutorialbot), users(:tutorialbot)
  end

  def test_update
    refute_permit nil, User
    refute_permit users(:admin), users(:user)
    refute_permit users(:user), users(:tutorialbot)
    assert_permit users(:admin), users(:admin)
    assert_permit users(:user), users(:user)
    assert_permit users(:tutorialbot), users(:tutorialbot)
  end

  def test_followers
    refute_permit nil, User
    assert_permit users(:user), users(:user)
    assert_permit users(:tutorialbot), users(:user)
    assert_permit users(:admin), users(:user)
  end

  def test_following
    refute_permit nil, User
    assert_permit users(:user), User
    assert_permit users(:tutorialbot), User
    assert_permit users(:admin), User
  end

  def test_index
    refute_permit nil, User
    refute_permit users(:user), User
    users(:user).right.user_index = true
    assert_permit users(:user), User
    refute_permit users(:tutorialbot), User
    assert_permit users(:admin), User
  end

  def test_create_relationship
    refute_permit nil, User
    refute_permit users(:user), users(:user)
    assert_permit users(:tutorialbot), users(:user)
    assert_permit users(:admin), users(:user)
  end

end

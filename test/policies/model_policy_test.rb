require 'test_helper'

class ModelPolicyTest < PolicyAssertions::Test

  def test_create
    refute_permit nil, Model
    refute_permit users(:user), Model
    assert_permit users(:admin), Model
  end

  def test_new
    refute_permit nil, Model
    refute_permit users(:user), Model
    users(:user).right.model_add = true
    assert_permit users(:user), Model
    assert_permit users(:admin), Model
  end

  def test_reupload
    refute_permit nil, models(:model_1)
    refute_permit users(:user), models(:model_1)
    refute_permit users(:tutorialbot), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_update
    refute_permit nil, models(:model_1)
    refute_permit users(:user), models(:model_1)
    refute_permit users(:tutorialbot), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_edit
    refute_permit nil, models(:model_1)
    refute_permit users(:user), models(:model_1)
    refute_permit users(:tutorialbot), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_destroy
    refute_permit nil, models(:model_1)
    refute_permit users(:user), models(:model_1)
    users(:user).right.model_delete = true
    assert_permit users(:user), models(:model_1)
    refute_permit users(:tutorialbot), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_download
    refute_permit nil, models(:model_1)
    assert_permit users(:user), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_show
    refute_permit nil, models(:model_1)
    assert_permit users(:user), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_show_logo
    refute_permit nil, models(:model_1)
    assert_permit users(:user), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

  def test_index
    refute_permit nil, models(:model_1)
    assert_permit users(:user), models(:model_1)
    assert_permit users(:admin), models(:model_1) #owner
  end

end

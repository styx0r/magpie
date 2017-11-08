require 'test_helper'

class ProjectPolicyTest < PolicyAssertions::Test

  def test_index
    refute_permit nil, Project
    assert_permit users(:user), Project
    assert_permit users(:admin), Project
  end

  def test_destroy
    refute_permit nil, projects(:project_1)
    refute_permit users(:user), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
    refute_permit users(:admin), projects(:project_1)
  end

  def test_new
    refute_permit nil, Project
    assert_permit users(:user), Project
    assert_permit users(:admin), Project
  end

  def test_create
    refute_permit nil, Project
    assert_permit users(:user), Project
    assert_permit users(:admin), Project
  end

  def test_edit
    refute_permit nil, Project
    refute_permit users(:user), Project
    refute_permit users(:admin), Project
  end

  def test_modelconfig # called via JS during project creation
    refute_permit nil, projects(:project_1)
    assert_permit users(:user), Project
    assert_permit users(:tutorialbot), projects(:project_1)
    assert_permit users(:admin), Project
  end

  def test_modeldescription # called via JS during project creation
    refute_permit nil, projects(:project_1)
    assert_permit users(:user), Project
    assert_permit users(:tutorialbot), projects(:project_1)
    assert_permit users(:admin), Project
  end

  def test_modelrevisions # called via JS during project creation
    refute_permit nil, projects(:project_1)
    assert_permit users(:user), Project
    assert_permit users(:tutorialbot), projects(:project_1)
    assert_permit users(:admin), Project
  end

  def test_show
    refute_permit nil, projects(:project_1)
    assert_permit users(:user), projects(:project_1)
    assert_permit users(:admin), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
    projects(:project_1).public = false
    refute_permit users(:user), projects(:project_1)
    refute_permit users(:admin), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
  end

  def test_toggle_public
    refute_permit nil, projects(:project_1)
    refute_permit users(:user), projects(:project_1)
    refute_permit users(:admin), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
  end

  def test_delete_marked_jobs
    refute_permit nil, projects(:project_1)
    refute_permit users(:user), projects(:project_1)
    refute_permit users(:admin), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
  end

  def test_owner
    refute_permit nil, projects(:project_1)
    refute_permit users(:user), projects(:project_1)
    refute_permit users(:admin), projects(:project_1)
    assert_permit users(:tutorialbot), projects(:project_1)
  end

  def test_job_create_toggle_public
    refute_permit nil, Project
    assert_permit users(:user), Project
    assert_permit users(:admin), Project
  end

end

require 'test_helper'

class JobPolicyTest < PolicyAssertions::Test

  def test_show
    refute_permit nil, Job
    refute_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
  end

  def test_create
    refute_permit nil, Job
    refute_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
  end

  def test_update
    refute_permit nil, Job
    refute_permit users(:user), jobs(:job_1)
    refute_permit users(:tutorialbot), jobs(:job_1)
  end

  def test_destroy
    refute_permit nil, Job
    refute_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
  end

  def test_download
    refute_permit nil, Job
    assert_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
    jobs(:job_1).project.public = false
    refute_permit users(:user), jobs(:job_1)
  end

  def test_download_config
    refute_permit nil, Job
    assert_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
    jobs(:job_1).project.public = false
    refute_permit users(:user), jobs(:job_1)
  end

  def test_read_more
    refute_permit nil, Job
    assert_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
    jobs(:job_1).project.public = false
    refute_permit users(:user), jobs(:job_1)
  end

  def test_read_less
    refute_permit nil, Job
    assert_permit users(:user), jobs(:job_1)
    assert_permit users(:tutorialbot), jobs(:job_1)
    jobs(:job_1).project.public = false
    refute_permit users(:user), jobs(:job_1)
  end
end

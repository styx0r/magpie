require 'test_helper'

class JobTest < ActiveSupport::TestCase

  def setup
    @tutorialbot = users(:tutorialbot)
    @job = jobs(:job_1)
  end

  test "number of jobs decreases with destroying a job" do
    assert_difference "@tutorialbot.projects.first.jobs.count", -1 do
      @job.destroy
    end
  end

  test "number of jobs do not decrease if it is another project" do
    assert_no_difference "@tutorialbot.projects.second.jobs.count" do
      @job.destroy
    end
  end

end

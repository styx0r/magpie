require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    @user = users(:tutorialbot)
    @project = projects(:project_1)
  end

  test "project validity?" do
    assert @project.valid?
    @project.name = ""
    assert_not @project.valid?
    @project.name = " "
    assert_not @project.valid?
  end

  test "if corresponding user is deleted, is project deleted?" do
    assert_difference "Project.count", - @user.projects.count do
      @user.destroy
    end
  end

end

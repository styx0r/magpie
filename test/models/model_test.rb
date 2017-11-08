require 'test_helper'

class ModelTest < ActiveSupport::TestCase

  def setup
    #@model = models(:model_delete)
    @model = models(:model_1)
    @user = users(:tutorialbot)
  end

  test "if a model is deleted, the corresponding jobs and projects should be deleted as well" do

  end

  test "model validity?" do
    @model_name = @model.name
    assert @model.valid?
    @model.name = ""
    assert_not @model.valid?
    @model.name = " "
    assert_not @model.valid?
    @model.name = @model_name
    assert @model.valid?
  end

  test "project deletion if model is deleted?" do
    assert_difference "@user.projects.count",
      - @user.projects.where(model_id: Model.where(name: "Versioned Sleep Studies").take.id).count do
      @model.destroy
    end
  end

  test "no project deletion if there is no relation to the model" do
    assert_no_difference "@user.projects.count" do
      models(:model_2).destroy
    end
  end

end

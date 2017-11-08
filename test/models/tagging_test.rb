require 'test_helper'

class TaggingTest < ActiveSupport::TestCase

  def setup
    @model = models(:model_1)
    @tag = taggings(:tagging_1)
  end

  test "if tag is deleted, model should still exist" do
    assert_no_difference "Model.count" do
      @tag.destroy
    end
  end

  test "if model is deleted, tag shouldn't be deleted" do
    assert_no_difference "Tagging.count" do
      @model.destroy
    end
  end

end

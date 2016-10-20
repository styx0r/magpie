class ChangeTagInHashtag < ActiveRecord::Migration[5.0]
  def change
    add_index :hashtags, :tag, unique: true
  end
end

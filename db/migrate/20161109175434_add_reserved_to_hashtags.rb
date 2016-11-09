class AddReservedToHashtags < ActiveRecord::Migration[5.0]
  def change
    add_column :hashtags, :reserved, :boolean, default: false
  end
end

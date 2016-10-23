class AddHashtagsCountToTaggings < ActiveRecord::Migration[5.0]
  def change
    add_column :hashtags, :taggings_count, :integer, null:false, default: 0
    Hashtag.reset_column_information
    Hashtag.all.each do |p|
      Hashtag.update_counters p.id, :taggings_count => p.taggings.length
    end
end
end

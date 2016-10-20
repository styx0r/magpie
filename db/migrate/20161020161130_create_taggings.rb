class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :hashtag, foreign_key: true
      t.belongs_to :micropost, foreign_key: true
      t.belongs_to :project, foreign_key: true
      t.belongs_to :model, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end

class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string  :tag

      t.timestamps null: false
    end
  end
end

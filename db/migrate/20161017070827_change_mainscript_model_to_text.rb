class ChangeMainscriptModelToText < ActiveRecord::Migration[5.0]
  def change
    change_column :models, :mainscript, :text
  end
end

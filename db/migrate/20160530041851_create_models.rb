class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.string :path
      t.string :mainscript

      t.timestamps null: false
    end
  end
end

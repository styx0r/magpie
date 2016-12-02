class AddCategoryToModel < ActiveRecord::Migration[5.0]
  def change
    add_column :models, :category, :string
  end
end

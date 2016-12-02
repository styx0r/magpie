class ChangeCategoryDefaultModels < ActiveRecord::Migration[5.0]
  def change
    change_column_default :models, :category, 'Uncategorized'
  end
end

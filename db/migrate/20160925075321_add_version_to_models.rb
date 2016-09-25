class AddVersionToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :models, :version, :string
  end
end

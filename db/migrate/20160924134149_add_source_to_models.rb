class AddSourceToModels < ActiveRecord::Migration[5.0]
  def change
        add_column :models, :source, :string
  end
end

class RemoveVersionFromModels < ActiveRecord::Migration[5.0]
  def change
    remove_column :models, :version
  end
end

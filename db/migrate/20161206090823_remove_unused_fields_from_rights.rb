class RemoveUnusedFieldsFromRights < ActiveRecord::Migration[5.0]
  def change
    remove_column :rights, :user_add, :boolean
    remove_column :rights, :docker_image_modify, :boolean
  end
end

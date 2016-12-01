class CreateRights < ActiveRecord::Migration[5.0]
  def change
    create_table :rights do |t|
      t.boolean :user_delete, default: false
      t.boolean :user_index, default: false
      t.boolean :user_add, default: false
      t.boolean :docker_image_modify, default: false
      t.boolean :projects_delete, default: false
      t.boolean :model_add, default: false
      t.boolean :model_delete, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end

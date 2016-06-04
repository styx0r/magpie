class AddIndexesOnForeignKeys < ActiveRecord::Migration
  def change
    add_index :jobs, :user_id
    add_index :jobs, :project_id
    add_index :models, :user_id
    add_index :projects, :user_id
    add_index :projects, :model_id
  end
end

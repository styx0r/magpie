class ChangeIdFormatInTables < ActiveRecord::Migration
  def up
   change_column :jobs, :user_id, :integer
   change_column :jobs, :project_id, :integer
   change_column :models, :user_id, :integer
   change_column :projects, :user_id, :integer
   change_column :projects, :model_id, :integer
  end

  def down
   change_column :jobs, :user_id, :varchar
   change_column :jobs, :project_id, :varchar
   change_column :models, :user_id, :varchar
   change_column :projects, :user_id, :varchar
   change_column :projects, :model_id, :varchar
  end
end

class AddColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :model_id, :string
    remove_column :projects, :model
  end
end

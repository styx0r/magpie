class AddRevisionToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :revision, :string
  end
end

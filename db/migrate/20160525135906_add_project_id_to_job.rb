class AddProjectIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :project_id, :string
  end
end

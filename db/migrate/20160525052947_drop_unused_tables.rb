class DropUnusedTables < ActiveRecord::Migration
  def change
    drop_table :model_jobs
    drop_table :userjobs
    drop_table :user_projects
  end
end

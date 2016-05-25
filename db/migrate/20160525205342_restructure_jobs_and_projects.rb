class RestructureJobsAndProjects < ActiveRecord::Migration
  def change
    add_column :jobs, :output, :text
    add_column :jobs, :resultfiles, :text
    remove_column :projects, :output
    remove_column :projects, :resultfiles
    remove_column :projects, :job_id
  end
end

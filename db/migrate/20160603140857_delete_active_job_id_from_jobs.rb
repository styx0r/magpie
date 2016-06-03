class DeleteActiveJobIdFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :active_job_id
  end
end

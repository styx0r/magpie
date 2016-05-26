class AddColumnJobIDtoJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :active_job_id, :string
  end
end

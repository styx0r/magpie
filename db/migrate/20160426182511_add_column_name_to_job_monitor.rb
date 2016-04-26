class AddColumnNameToJobMonitor < ActiveRecord::Migration
  def change
    add_column :job_monitors, :status, :string
  end
end

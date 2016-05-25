class DropTableJobMonitor < ActiveRecord::Migration
  def change
    drop_table :job_monitors
  end
end

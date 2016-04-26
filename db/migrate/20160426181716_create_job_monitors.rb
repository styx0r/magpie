class CreateJobMonitors < ActiveRecord::Migration
  def change
    create_table :job_monitors do |t|
      t.string :job_id
      t.string :user

      t.timestamps null: false
    end
  end
end

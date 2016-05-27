class AddArgumentsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :arguments, :text
  end
end

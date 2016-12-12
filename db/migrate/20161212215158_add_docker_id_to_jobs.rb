class AddDockerIdToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :docker_id, :string
  end
end

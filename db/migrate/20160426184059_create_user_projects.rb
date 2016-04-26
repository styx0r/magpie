class CreateUserProjects < ActiveRecord::Migration
  def change
    create_table :user_projects do |t|
      t.string :user
      t.string :job_id
      t.string :name

      t.timestamps null: false
    end
  end
end

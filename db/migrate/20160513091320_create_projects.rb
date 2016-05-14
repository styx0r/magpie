class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :user
      t.string :job_id
      t.string :name
      t.string :model
      t.text :output
      t.text :resultfiles

      t.timestamps null: false
    end
  end
end

class AddResultFilesToUserProject < ActiveRecord::Migration
  def change
    add_column :user_projects, :resultfiles, :text
  end
end

class AddOutputToUserProject < ActiveRecord::Migration
  def change
    add_column :user_projects, :output, :text
  end
end

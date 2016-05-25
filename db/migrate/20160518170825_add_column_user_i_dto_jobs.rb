class AddColumnUserIDtoJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :user_id, :string
  end
end

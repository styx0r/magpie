class AddModelToUserProject < ActiveRecord::Migration
  def change
    add_column :user_projects, :model, :string
  end
end

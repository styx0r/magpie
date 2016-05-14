class AddUserIdtoProject < ActiveRecord::Migration
  def change
        add_column :projects, :user_id, :string
  end
end

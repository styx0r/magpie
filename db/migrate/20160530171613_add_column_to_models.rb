class AddColumnToModels < ActiveRecord::Migration
  def change
    add_column :models, :description, :text
    add_column :models, :help, :text
    add_column :models, :user_id, :string
  end
end

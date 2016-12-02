class AddLogoToModel < ActiveRecord::Migration[5.0]
  def change
    add_column :models, :logo, :binary
  end
end

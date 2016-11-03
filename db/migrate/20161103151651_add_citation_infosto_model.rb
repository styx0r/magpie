class AddCitationInfostoModel < ActiveRecord::Migration[5.0]
  def change
    add_column :models, :doi, :string
    add_column :models, :citation, :string
  end
end

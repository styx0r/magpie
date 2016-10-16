class SetDefaultForGuest < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :guest, :boolean, default: false
  end
end

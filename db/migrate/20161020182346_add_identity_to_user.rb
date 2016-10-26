class AddIdentityToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :identity, :string
    add_index :users, :identity, unique: true
  end
end

class AddMentionstoMicropost < ActiveRecord::Migration[5.0]
  def change
    add_column :microposts, :mentions, :string
  end
end

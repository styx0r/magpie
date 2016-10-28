class AddHighlightToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :highlight, :string, null:false, default: "neutral"
  end
end

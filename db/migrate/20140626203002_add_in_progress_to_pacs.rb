class AddInProgressToPacs < ActiveRecord::Migration
  def change
  	add_column :pacs, :in_progress, :boolean
  end
end

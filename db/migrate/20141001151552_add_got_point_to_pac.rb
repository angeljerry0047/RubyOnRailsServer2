class AddGotPointToPac < ActiveRecord::Migration
  def change
    add_column :pacs, :got_point, :boolean, :default => false
  end
end

class AddOnlineInfoToPac < ActiveRecord::Migration
  def change
    add_column :pacs, :online_info, :text
  end
end

class AddPacsIsPublic < ActiveRecord::Migration
  def change
    add_column :pacs, :is_public, :boolean, default: false
  end
end

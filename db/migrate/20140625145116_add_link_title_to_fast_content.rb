class AddLinkTitleToFastContent < ActiveRecord::Migration
  def change
    add_column :fast_contents, :link_title, :string
  end
end

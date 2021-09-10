class AddViaShopifyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :via_shopify, :boolean
  end
end

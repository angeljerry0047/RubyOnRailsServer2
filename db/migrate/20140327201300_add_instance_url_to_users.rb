class AddInstanceUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instance_url, :string
    add_column :users, :refresh_token, :string
    add_column :users, :salesforce_id, :string
  end
end

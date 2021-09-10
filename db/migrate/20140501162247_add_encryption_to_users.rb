class AddEncryptionToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_salesforce_id, :string
  end
end

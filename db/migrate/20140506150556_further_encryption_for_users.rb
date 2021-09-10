class FurtherEncryptionForUsers < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_access_key, :string
  	add_column :users, :encrypted_uid, :string
  end
end

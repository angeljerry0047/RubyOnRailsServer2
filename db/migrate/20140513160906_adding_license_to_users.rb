class AddingLicenseToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :active_license, :boolean 	
  	add_column :users, :licensed_date, :date
  end
end

class AddingUserLicensesToOrganizations < ActiveRecord::Migration
  def change
  	add_column :organizations, :user_licenses, :integer 	
  end
end

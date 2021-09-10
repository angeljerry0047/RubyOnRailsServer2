class ChangeChargeIdInUserLicensePurchase < ActiveRecord::Migration
  def change
  	remove_column :user_license_purchases, :charge_id
  	add_column :user_license_purchases, :charge_id, :string 	
  end
end

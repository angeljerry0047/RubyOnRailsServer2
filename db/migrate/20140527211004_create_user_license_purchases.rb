class CreateUserLicensePurchases < ActiveRecord::Migration
  def change
    create_table :user_license_purchases do |t|
      t.integer :user_id
      t.integer :organization_id
      t.integer :licenses_purchased
      t.integer :charge_id

      t.timestamps
    end
  end
end

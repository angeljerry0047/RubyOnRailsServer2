class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :used
      t.integer :organization_id

      t.timestamps
    end
  end
end

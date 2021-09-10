class CreateOpportunityCouponUses < ActiveRecord::Migration
  create_table :opportunity_coupon_uses do |t|
    t.integer :opportunity_coupon_id
    t.integer :user_id
    t.integer :opportunity_id
    t.timestamps
  end
end

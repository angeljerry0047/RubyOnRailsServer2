class AddOpportunityCouponColumnToOpportunityApplication < ActiveRecord::Migration
  def change
    add_column :opportunity_applications, :opportunity_coupon_id, :integer
  end
end

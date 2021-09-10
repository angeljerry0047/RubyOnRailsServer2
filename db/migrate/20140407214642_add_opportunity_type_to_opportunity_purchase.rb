class AddOpportunityTypeToOpportunityPurchase < ActiveRecord::Migration
  def change
  	add_column :opportunity_purchases, :skill_type, :string 	
  	add_column :opportunity_coupon_uses, :skill_type, :string
  end
end

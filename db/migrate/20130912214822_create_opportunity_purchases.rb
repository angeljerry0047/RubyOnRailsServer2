class CreateOpportunityPurchases < ActiveRecord::Migration
  def change
    create_table :opportunity_purchases do |t|
      t.integer :opportunity_id
      t.string :charge_id
      t.integer :user_id

      t.timestamps
    end
  end
end

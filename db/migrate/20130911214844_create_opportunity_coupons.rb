class CreateOpportunityCoupons < ActiveRecord::Migration
  def change
    create_table :opportunity_coupons do |t|
      t.string :code
      t.integer :organization_id
      t.boolean :valid, :default => true
      t.timestamps
    end
  end
end

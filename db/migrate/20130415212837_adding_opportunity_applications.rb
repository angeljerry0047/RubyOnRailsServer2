class AddingOpportunityApplications < ActiveRecord::Migration
  def change
    create_table :opportunity_applications do |t|
      t.integer :opportunity_id
      t.integer :user_id
      t.text :reason_to_apply
      t.timestamps
    end
    
    add_index :opportunity_applications, :user_id
    add_index :opportunity_applications, :opportunity_id
  end
end

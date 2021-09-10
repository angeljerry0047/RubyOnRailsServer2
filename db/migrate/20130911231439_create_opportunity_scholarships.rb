class CreateOpportunityScholarships < ActiveRecord::Migration
  def change
    create_table :opportunity_scholarships do |t|
      t.integer :opportunity_id
      t.integer :user_id
      t.text :reason_to_apply
      t.integer :opportunity_scholarship_states_id, :default => 1
      t.text :reason_of_approval
      t.integer :approval_user_id
      t.timestamps
    end
    
    add_index :opportunity_scholarships, :user_id
    add_index :opportunity_scholarships, :opportunity_id
  end
end

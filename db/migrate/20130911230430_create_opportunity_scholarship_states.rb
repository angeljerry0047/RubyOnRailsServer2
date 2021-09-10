class CreateOpportunityScholarshipStates < ActiveRecord::Migration
  def change
    create_table :opportunity_scholarship_states do |t|
      t.string :description

      t.timestamps
    end
    
    OpportunityScholarshipState.create!(:description => 'In Progress')
    OpportunityScholarshipState.create!(:description => 'Approved')
    OpportunityScholarshipState.create!(:description => 'Rejected')        
  end
end

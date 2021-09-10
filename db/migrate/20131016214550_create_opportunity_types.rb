class CreateOpportunityTypes < ActiveRecord::Migration
 def change
    create_table :opportunity_types do |t|
      t.string :name
      t.timestamps
    end
    
    OpportunityType.create!(:name => 'In person')
    OpportunityType.create!(:name => 'GoToMeeting')
    OpportunityType.create!(:name => 'GoToTraining')
    OpportunityType.create!(:name => 'GoToWebinar')
  end
end

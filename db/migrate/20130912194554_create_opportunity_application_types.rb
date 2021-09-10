class CreateOpportunityApplicationTypes < ActiveRecord::Migration
  def change
    create_table :opportunity_application_types do |t|
      t.string :description

      t.timestamps
    end
    
    OpportunityApplicationType.create!(:description => 'Normal')
    OpportunityApplicationType.create!(:description => 'Scholarship')
    OpportunityApplicationType.create!(:description => 'Coupon')
    OpportunityApplicationType.create!(:description => 'Purchase')
  end
end

class AddScholarshipIdToOpportunityApplications < ActiveRecord::Migration
  def change
    add_column :opportunity_applications, :opportunity_scholarship_id, :integer
  end
end

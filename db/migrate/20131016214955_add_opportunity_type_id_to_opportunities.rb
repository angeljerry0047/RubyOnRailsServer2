class AddOpportunityTypeIdToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :opportunity_type_id, :integer
  end
end

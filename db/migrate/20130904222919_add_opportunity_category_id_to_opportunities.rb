class AddOpportunityCategoryIdToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :opportunity_category_id, :integer
  end
end

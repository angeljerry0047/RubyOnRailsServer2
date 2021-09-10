class AddRecommendableToOpportunityCategories < ActiveRecord::Migration
  def change
    add_column :opportunity_categories, :recommendable, :boolean
  end
end

class AddBooleanToRecommendationApplication < ActiveRecord::Migration
  def change
    add_column :recommendation_applications, :complete_plan, :boolean, :default => false
  end
end

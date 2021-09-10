class AddPerformanceRatingToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :con_performance, :string
  end
end

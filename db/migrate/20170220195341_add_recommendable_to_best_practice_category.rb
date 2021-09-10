class AddRecommendableToBestPracticeCategory < ActiveRecord::Migration
  def change
    add_column :best_practice_categories, :recommendable, :boolean
  end
end

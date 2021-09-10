class AddConnectionExplanationToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :con_text, :text
  end
end

class AddInternalToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :internal, :boolean
  end
end

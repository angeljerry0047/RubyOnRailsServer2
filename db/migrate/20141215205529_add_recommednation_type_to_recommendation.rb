class AddRecommednationTypeToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :rec_type, :string
  end
end

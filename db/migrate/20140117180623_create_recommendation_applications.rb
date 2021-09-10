class CreateRecommendationApplications < ActiveRecord::Migration
  def change
    create_table :recommendation_applications do |t|
      t.integer :recommendation_id
      t.integer :user_id

      t.timestamps
    end
  end
end

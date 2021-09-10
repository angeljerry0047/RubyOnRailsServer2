class AddApplicationMessageToRecommendationApplications < ActiveRecord::Migration
  def change
    add_column :recommendation_applications, :application_message, :text
  end
end

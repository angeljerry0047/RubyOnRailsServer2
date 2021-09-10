class AddRecommendationApplicationIdToMentorActionPlan < ActiveRecord::Migration
  def change
    add_column :mentor_action_plans, :recommendation_application_id, :integer
    rename_column :mentor_action_plans, :opportunity_id, :opportunity_application_id
  end
end

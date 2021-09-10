class AddNeededFieldsToCoachAndVolunteer < ActiveRecord::Migration
  def change
  	add_column :coach_action_plans, :participant_id, :integer
  	add_column :volunteer_action_plans, :liason_id, :integer
  	add_column :coach_action_plans, :recommendation_application_id, :integer
    rename_column :coach_action_plans, :opportunity_id, :opportunity_application_id
    add_column :volunteer_action_plans, :recommendation_application_id, :integer
    rename_column :volunteer_action_plans, :opportunity_id, :opportunity_application_id
  end
end

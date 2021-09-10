class FixColumnNameForVolunteerActionPlansUsers < ActiveRecord::Migration
  def change
  	rename_column :volunteer_action_plans_users, :coach_action_plan_id, :volunteer_action_plan_id
  end
end

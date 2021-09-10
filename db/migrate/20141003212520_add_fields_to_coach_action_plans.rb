class AddFieldsToCoachActionPlans < ActiveRecord::Migration
  def change
  	add_column :coach_action_plans, :start_date, :datetime
  	add_column :coach_action_plans, :end_date, :datetime
  	add_column :coach_action_plans, :goals, :text
  	add_column :coach_action_plans, :participant_action_items, :text
  	add_column :coach_action_plans, :coach_action_items, :text
  	add_column :coach_action_plans, :participant_deadlines, :datetime
  	add_column :coach_action_plans, :coach_deadlines, :datetime
  	add_column :coach_action_plans, :success_indicators, :text
  	add_column :coach_action_plans, :follow_up_meetings, :text
    add_column :coach_action_plans, :participant_name, :string
  end
end

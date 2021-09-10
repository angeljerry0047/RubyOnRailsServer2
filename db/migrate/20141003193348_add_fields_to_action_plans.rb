class AddFieldsToActionPlans < ActiveRecord::Migration
  def change
  	add_column :mentor_action_plans, :start_date, :datetime
  	add_column :mentor_action_plans, :end_date, :datetime
  	add_column :mentor_action_plans, :goals, :text
  	add_column :mentor_action_plans, :participant_action_items, :text
  	add_column :mentor_action_plans, :mentor_action_items, :text
  	add_column :mentor_action_plans, :participant_deadlines, :datetime
  	add_column :mentor_action_plans, :mentor_deadlines, :datetime
  	add_column :mentor_action_plans, :success_indicators, :text
  	add_column :mentor_action_plans, :follow_up_meetings, :text
  end
end

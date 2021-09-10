class AddFieldsToVolunteerActionPlans < ActiveRecord::Migration
  def change
  	add_column :volunteer_action_plans, :start_date, :datetime
  	add_column :volunteer_action_plans, :end_date, :datetime
  	add_column :volunteer_action_plans, :goals, :text
  	add_column :volunteer_action_plans, :liason_action_items, :text
  	add_column :volunteer_action_plans, :volunteer_action_items, :text
  	add_column :volunteer_action_plans, :liason_deadlines, :datetime
  	add_column :volunteer_action_plans, :volunteer_deadlines, :datetime
  	add_column :volunteer_action_plans, :success_indicators, :text
  	add_column :volunteer_action_plans, :follow_up_meetings, :text
    add_column :volunteer_action_plans, :liason_name, :string
  end
end

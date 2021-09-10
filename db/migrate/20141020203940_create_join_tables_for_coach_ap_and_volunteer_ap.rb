class CreateJoinTablesForCoachApAndVolunteerAp < ActiveRecord::Migration
  def change
  	create_table :coach_action_plans_users, :id => false do |t|
  		t.integer :coach_action_plan_id
  		t.integer :user_id
  		t.integer :participant_id
  	end
  	create_table :volunteer_action_plans_users, :id => false do |t|
  		t.integer :coach_action_plan_id
  		t.integer :user_id
  		t.integer :liason_id
  	end
  end
end

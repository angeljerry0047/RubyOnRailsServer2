class MentorActionPlansUsers < ActiveRecord::Migration
  def change
  	create_table :mentor_action_plans_users, :id => false do |t|
  		t.integer :mentor_action_plan_id
  		t.integer :user_id
  	end
  end
end

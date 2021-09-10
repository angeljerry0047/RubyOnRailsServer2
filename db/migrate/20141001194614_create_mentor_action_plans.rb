class CreateMentorActionPlans < ActiveRecord::Migration
  def change
    create_table :mentor_action_plans do |t|
      t.integer :user_id
      t.integer :opportunity_id

      t.timestamps
    end
  end
end

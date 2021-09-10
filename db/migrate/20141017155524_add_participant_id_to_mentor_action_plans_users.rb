class AddParticipantIdToMentorActionPlansUsers < ActiveRecord::Migration
  def change
    add_column :mentor_action_plans_users, :participant_id, :integer
  end
end

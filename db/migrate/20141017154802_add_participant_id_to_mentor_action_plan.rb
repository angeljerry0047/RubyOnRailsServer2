class AddParticipantIdToMentorActionPlan < ActiveRecord::Migration
  def change
    add_column :mentor_action_plans, :participant_id, :integer
  end
end

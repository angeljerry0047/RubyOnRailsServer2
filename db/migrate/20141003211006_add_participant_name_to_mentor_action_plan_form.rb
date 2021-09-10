class AddParticipantNameToMentorActionPlanForm < ActiveRecord::Migration
  def change
    add_column :mentor_action_plans, :participant_name, :string
  end
end

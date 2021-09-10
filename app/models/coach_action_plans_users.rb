# == Schema Information
#
# Table name: coach_action_plans_users
#
#  coach_action_plan_id :integer
#  user_id              :integer
#  participant_id       :integer
#

class CoachActionPlansUsers < ActiveRecord::Base
  def self.permitted(params)
    coach_action_plan_users_whitelist = [:coach_action_plan_id, :user_id, :participant_id]
    params.permit(:coach_action_plans_users).params(*coach_action_plan_users_whitelist)
  end
  
  belongs_to :coach_action_plan
  belongs_to :user
  belongs_to :participant, :class_name => "User"
end

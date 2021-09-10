# == Schema Information
#
# Table name: mentor_action_plans_users
#
#  mentor_action_plan_id :integer
#  user_id               :integer
#  participant_id        :integer
#

class MentorActionPlansUsers < ActiveRecord::Base
  def self.permitted(params)
    mentor_action_plans_users_whitelist = [:mentor_action_plan_id, :user_id, :participant_id]
    params.permit(mentor_action_plans_users: mentor_action_plans_users_whitelist)
  end
  
  belongs_to :mentor_action_plan
  belongs_to :user
  belongs_to :participant, :class_name => "User"
end

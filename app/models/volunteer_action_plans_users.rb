# == Schema Information
#
# Table name: volunteer_action_plans_users
#
#  volunteer_action_plan_id :integer
#  user_id                  :integer
#  liason_id                :integer
#

class VolunteerActionPlansUsers < ActiveRecord::Base
  def self.permitted(params)
    volunteer_action_plan_user_whitelist = [:volunteer_action_plan_id, :user_id, :liason_id]
    params.permit(volunteer_action_plans_user: volunteer_action_plan_user_whitelist)
  end
  
  belongs_to :volunteer_action_plan
  belongs_to :user
  belongs_to :liason, :class_name => "User"
end

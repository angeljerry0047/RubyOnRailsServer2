# == Schema Information
#
# Table name: volunteer_action_plans
#
#  id                            :integer          not null, primary key
#  user_id                       :integer
#  opportunity_application_id    :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  start_date                    :datetime
#  end_date                      :datetime
#  goals                         :text
#  liason_action_items           :text
#  volunteer_action_items        :text
#  liason_deadlines              :datetime
#  volunteer_deadlines           :datetime
#  success_indicators            :text
#  follow_up_meetings            :text
#  liason_name                   :string(255)
#  liason_id                     :integer
#  recommendation_application_id :integer
#

class VolunteerActionPlan < ActiveRecord::Base
  def self.permitted(params)
    volunteer_action_plan_whitelist = [
      :opportunity_application_id,
      :user_id,
      :start_date,
      :end_date,
      :goals,
      :volunteer_action_items,
      :liason_action_items,
      :volunteer_deadlines,
      :liason_deadlines,
      :success_indicators,
      :follow_up_meetings,
      :liason_name,
      :liason_id,
      :recommendation_application_id
    ]

    params.permit(volunteer_action_plan: volunteer_action_plan_whitelist)
  end

  belongs_to :user
  belongs_to :liason, :class_name => "User"
  belongs_to :opportunity_application
  belongs_to :recommendation_application

  after_create :notify_users

  def notify_users
    Notifier.new_volunteer_action_plan(self).deliver_now!
  end
end

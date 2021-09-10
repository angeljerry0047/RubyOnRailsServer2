# == Schema Information
#
# Table name: coach_action_plans
#
#  id                            :integer          not null, primary key
#  user_id                       :integer
#  opportunity_application_id    :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  start_date                    :datetime
#  end_date                      :datetime
#  goals                         :text
#  participant_action_items      :text
#  coach_action_items            :text
#  participant_deadlines         :datetime
#  coach_deadlines               :datetime
#  success_indicators            :text
#  follow_up_meetings            :text
#  participant_name              :string(255)
#  participant_id                :integer
#  recommendation_application_id :integer
#

class CoachActionPlan < ActiveRecord::Base
  def self.permitted(params)
    coach_action_plan_whitelist = [
      :opportunity_application_id,
      :user_id,
      :start_date,
      :end_date,
      :goals,
      :coach_action_items,
      :participant_action_items,
      :coach_deadlines,
      :participant_deadlines,
      :success_indicators,
      :follow_up_meetings,
      :participant_name,
      :participant_id,
      :recommendation_application_id
    ]

    params.permit(coach_action_plan: coach_action_plan_whitelist)
  end

  belongs_to :user
  belongs_to :participant, :class_name => "User"
  belongs_to :opportunity_application
  belongs_to :recommendation_application

  after_create :notify_users

  def notify_users
    Notifier.new_coach_action_plan(self).deliver_now!
  end

end

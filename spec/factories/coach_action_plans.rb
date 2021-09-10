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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :coach_action_plan do
    user_id { 1 }
    opportunity_id { 1 }
  end
end

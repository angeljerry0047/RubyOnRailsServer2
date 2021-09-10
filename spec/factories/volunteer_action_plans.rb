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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :volunteer_action_plan do
    user_id { 1 }
    opportunity_id { 1 }
  end
end

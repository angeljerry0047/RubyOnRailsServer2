# == Schema Information
#
# Table name: pacs
#
#  id                        :integer          not null, primary key
#  complete                  :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :text
#  webcast_id                :string(255)
#  webcast_facilitator_id    :string(255)
#  opportunity_type_id       :integer
#  category                  :string(255)
#  learning_objectives       :text
#  start_date                :datetime
#  deadline_date             :datetime
#  start_time                :string(255)
#  end_time                  :string(255)
#  max_students              :integer
#  min_students              :integer
#  facility_id               :integer
#  owner_id                  :integer
#  title                     :string(255)
#  city                      :string(255)
#  state                     :string(255)
#  organization_id           :integer
#  in_progress               :boolean
#  approval_code             :string(255)
#  got_point                 :boolean          default(FALSE)
#  approval_status           :boolean          default(FALSE)
#  is_public                 :boolean          default(FALSE)
#  online_info               :text
#  best_practice_category_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :pac do
    complete { false }
  end
end

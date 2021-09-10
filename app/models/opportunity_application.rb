# == Schema Information
#
# Table name: opportunity_applications
#
#  id                               :integer          not null, primary key
#  opportunity_id                   :integer
#  user_id                          :integer
#  reason_to_apply                  :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  opportunity_applications_type_id :integer          default(1)
#  foreign_key                      :integer
#  complete_plan                    :boolean          default(FALSE)
#

class OpportunityApplication < ActiveRecord::Base
  def self.permitted(params)
    opportunities_application_whitelist = [:opportunity_id, :user_id, :reason_to_apply, :opportunity_applications_type_id, :foreign_key, :complete_plan]

    params.permit(opportunity_applications: opportunities_application_whitelist)
  end

  validates_presence_of   :user_id, :opportunity_id
  validates_uniqueness_of :user_id, :scope => :opportunity_id, :message => "You've already applied for this skill."

  belongs_to :opportunity
  belongs_to :user
  belongs_to :opportunity_application_type

  has_many :mentor_action_plans
  has_many :coach_action_plans
  has_many :volunteer_action_plans

  after_create :notify_manager

  def sort_by_id
    self.id.to_s + "o"
  end

  def sort_by_name
    self.user.name
  end

  private

  def notify_manager
    @opportunity = opportunity

    if @opportunity.opportunity_type_id == 1 || @opportunity.opportunity_type_id == 2
      Notifier.new_opportunity_application(self).deliver_now!
    end

    Notifier.new_manager_opportunity_application(self).deliver_now!
  end

  def send_feedback_request
    Notifier.skill_completed_email(self).deliver_now!
  end

end

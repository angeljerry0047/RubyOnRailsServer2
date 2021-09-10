# == Schema Information
#
# Table name: recommendation_applications
#
#  id                  :integer          not null, primary key
#  recommendation_id   :integer
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_message :text
#  complete_plan       :boolean          default(FALSE)
#

class RecommendationApplication < ActiveRecord::Base
  def self.permitted(params)
    recommendation_application_whitelist = [
      :recommendation_id,
      :user_id,
      :application_message,
      :complete_plan
    ]

    params.permit(recommendation_application: recommendation_application_whitelist)
  end

  validates_presence_of :user_id, :recommendation_id
  validates_uniqueness_of :user_id, :scope => :recommendation_id, :message => "You've already applied for this skill."


  belongs_to :recommendation
  belongs_to :user

  has_many :mentor_action_plans
  has_many :coach_action_plans
  has_many :volunteer_action_plans

  after_create :notify_manager

  def sort_by_id
    self.id.to_s + "r"
  end

  def sort_by_name
    self.user.name
  end

  private
  def notify_manager
    Notifier.new_recommendation_application(self).deliver_now!
  end

  def send_feedback_request
    Notifier.recommendation_completed_email(self).deliver_now!
  end
end

# == Schema Information
#
# Table name: assessment_purchases
#
#  id                   :integer          not null, primary key
#  assessment_report_id :integer
#  assessment_id        :integer
#  charge_id            :string(255)
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class AssessmentPurchase < ActiveRecord::Base
  def self.permitted(params)
    asssessment_purchase = [:assessment_id, :assessment_report_id, :charge_id, :user_id]
    params.permit(assessment_purchase: asssessment_purchase)
  end
  
  belongs_to :user
  belongs_to :assessment_report
  belongs_to :assessment
  
  validates_presence_of :user_id, :assessment_id
end

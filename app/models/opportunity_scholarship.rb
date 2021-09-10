# == Schema Information
#
# Table name: opportunity_scholarships
#
#  id                                :integer          not null, primary key
#  opportunity_id                    :integer
#  user_id                           :integer
#  reason_to_apply                   :text
#  opportunity_scholarship_states_id :integer          default(1)
#  reason_of_approval                :text
#  approval_user_id                  :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class OpportunityScholarship < ActiveRecord::Base
  def self.permitted(params)
    opportunity_scholarships_whitelist = [
      :opportunity_id,
      :user_id,
      :reason_to_apply,
      :opportunity_scholarship_states_id,
      :reason_of_approval,
      :approval_user_id
    ]

    params.permit(opportunity_scholarship: opportunity_scholarships_whitelist)
  end
  
  validates_presence_of   :user_id, :opportunity_id
  validates_uniqueness_of :user_id, :scope => :opportunity_id, :message => "You've already applied for Scholarship."
  
  belongs_to :opportunity
  belongs_to :user
  belongs_to :opportunity_scholarship_state    
  
  after_create :notify_approver
  
  def notify_approver
    Notifier.scholarship_request(self).deliver_now!
  end  
  
end

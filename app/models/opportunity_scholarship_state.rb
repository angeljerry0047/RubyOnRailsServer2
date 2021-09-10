# == Schema Information
#
# Table name: opportunity_scholarship_states
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OpportunityScholarshipState < ActiveRecord::Base
  def self.permitted(params)
    opportunity_scholarship_state_whitelist = [:description]
    params.permit(opportunity_scholarship_state: opportunity_scholarship_state_whitelist)
  end
end

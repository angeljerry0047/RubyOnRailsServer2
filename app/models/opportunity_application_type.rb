# == Schema Information
#
# Table name: opportunity_application_types
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OpportunityApplicationType < ActiveRecord::Base
  def self.permitted(params)
    opportunity_application_type_whitelist = [:description]
    params.permit(opportunity_application_type: opportunity_application_type_whitelist)
  end
end

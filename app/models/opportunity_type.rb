# == Schema Information
#
# Table name: opportunity_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OpportunityType < ActiveRecord::Base
  def self.permitted(params)
    opportunity_type_whitelist = [:name]
    params.permit(opportunity_type: opportunity_type_whitelist)
  end

  has_many :opportunities
  has_many :pacs
end

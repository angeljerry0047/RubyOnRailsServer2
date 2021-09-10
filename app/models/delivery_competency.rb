# == Schema Information
#
# Table name: delivery_competencies
#
#  id                      :integer          not null, primary key
#  opportunity_category_id :integer
#  competency_id           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class DeliveryCompetency < ActiveRecord::Base
  def self.permitted(params)
    delivery_competency_whitelist = [:competency_id, :opportunity_category_id]
    params.permit(delivery_competency: delivery_competency_whitelist)
  end

  belongs_to :competency
  belongs_to :opportunity_category
end

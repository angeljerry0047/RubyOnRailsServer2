# == Schema Information
#
# Table name: developed_competencies
#
#  id             :integer          not null, primary key
#  competency_id  :integer
#  opportunity_id :integer
#  description    :text
#

class DevelopedCompetency < ActiveRecord::Base
  def self.permitted(params)
    developed_competency_whitelist = [:competency_id, :description, :opportunity_id]
    params.permit(developed_competency: developed_competency_whitelist)
  end
  
  validates_presence_of :competency_id
  
  belongs_to :competency
  belongs_to :opportunity
end

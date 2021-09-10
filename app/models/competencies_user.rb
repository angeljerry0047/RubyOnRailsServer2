# == Schema Information
#
# Table name: competencies_users
#
#  user_id       :integer
#  competency_id :integer
#

class CompetenciesUser < ActiveRecord::Base
  def self.permitted(params)
    competencies_user_whitelist = [:competency_id, :user_id]
    params.permit(competencies_user: competencies_user_whitelist)
  end
  
  belongs_to :user
  belongs_to :competency
end

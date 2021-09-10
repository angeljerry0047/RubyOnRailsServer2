# == Schema Information
#
# Table name: opportunities_users
#
#  opportunity_id :integer
#  user_id        :integer
#

class OpportunitiesUser < ActiveRecord::Base
  def self.permitted(params)
    opportunities_user_whitelist = [:opportunity_id, :user_id]
    params.permit(opportunities_user: opportunities_user_whitelist)
  end
  
  belongs_to :user
end

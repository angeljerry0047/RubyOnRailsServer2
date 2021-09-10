# == Schema Information
#
# Table name: webcast_facilitators
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  access_token  :string(255)
#  organizer_key :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class WebcastFacilitator < ActiveRecord::Base
  def self.permitted(params)
    webcast_facilitator_whitelist = [:access_token, :email, :organizer_key]
    params.permit(webcast_facilitator: webcast_facilitator_whitelist)
  end

  has_many :opportunities
  has_many :pacs
end

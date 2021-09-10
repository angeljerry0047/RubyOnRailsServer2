# == Schema Information
#
# Table name: facilities
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  city          :string(255)
#  state         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  address       :string(255)
#  map_location  :string(255)
#  approval_name :string(255)
#  approval_mail :string(255)
#

class Facility < ActiveRecord::Base

  def self.permitted(params)
    facilies_whitelist = [:map_location, :name, :city, :state, :created_at, :updated_at, :address, :approval_name, :approval_mail]
    params.permit(facility: facilies_whitelist)
  end
  
  validates_presence_of :name   
end

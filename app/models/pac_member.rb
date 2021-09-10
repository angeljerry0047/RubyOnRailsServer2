# == Schema Information
#
# Table name: pac_members
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  pac_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean
#

class PacMember < ActiveRecord::Base
  def self.permitted(params)
    pac_member_whitelist = [:member_id, :pac_id, :approved]
    params.permit(pac_member: pac_member_whitelist)
  end

  belongs_to :pac
  belongs_to :member, :class_name => "User"
end

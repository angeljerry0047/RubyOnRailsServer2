# == Schema Information
#
# Table name: group_admins
#
#  id       :integer          not null, primary key
#  group_id :integer
#  admin_id :integer
#

class GroupAdmin < ActiveRecord::Base
  def self.permitted(params)
    group_admin_whitelist = [:group_id, :admin_id]
    params.permit(group_admin: group_admin_whitelist)
  end
  
  belongs_to :managed_group, :class_name => "Organization", :foreign_key => 'group_id'
  belongs_to :admin, :class_name => "User", :foreign_key => 'admin_id'
end

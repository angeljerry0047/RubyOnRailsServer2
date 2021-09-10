# == Schema Information
#
# Table name: user_groups
#
#  id        :integer          not null, primary key
#  group_id  :integer
#  member_id :integer
#  approved  :boolean          default(FALSE)
#

class UserGroup < ActiveRecord::Base
  def self.attribute_whitelist
    [:group_id, :member_id, :approved]
  end

  def self.permitted(params)
    params.permit(user_group: self.attribute_whitelist)
  end
  
  belongs_to :group, :class_name => "Organization", :foreign_key => 'group_id'
  belongs_to :member, :class_name => "User", :foreign_key => 'member_id'
end

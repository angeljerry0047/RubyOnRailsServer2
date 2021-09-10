# == Schema Information
#
# Table name: position_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PositionType < ActiveRecord::Base
  def self.permitted(params)
    position_type_whitelist = [:name, :parent_id]
    params.permit(position_type: position_type_whitelist)
  end

  acts_as_tree
end

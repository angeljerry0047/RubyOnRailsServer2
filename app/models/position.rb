# == Schema Information
#
# Table name: positions
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Position < ActiveRecord::Base
  def self.permitted(params)
    position_whitelist = [:description, :title]
    params.permit(position: position_whitelist)
  end
end

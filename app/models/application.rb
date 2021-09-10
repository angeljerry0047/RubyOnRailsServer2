# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  position_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Application < ActiveRecord::Base
  def self.permitted(params)
    application_whitelist = [:position_id, :user_id]
    params.permit(application: application_whitelist)
  end
end

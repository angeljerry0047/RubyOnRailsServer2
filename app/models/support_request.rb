# == Schema Information
#
# Table name: support_requests
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  email       :string(255)
#  description :text
#  issue_time  :string(255)
#  ip_address  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SupportRequest < ActiveRecord::Base
  validates :name, :email, :description, presence: true
end

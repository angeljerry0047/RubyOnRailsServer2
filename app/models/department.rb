# == Schema Information
#
# Table name: departments
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Department < ActiveRecord::Base
  def self.permitted(params)
    department_whitelist = [:name, :organization_id]
    params.permit(department: department_whitelist)
  end

  belongs_to :organization
  has_many :fast_content_departments
  has_many :fast_contents, :through => :fast_content_departments
end

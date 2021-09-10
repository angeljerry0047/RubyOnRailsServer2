# == Schema Information
#
# Table name: fast_content_departments
#
#  fast_content_id :integer
#  department_id   :integer
#

class FastContentDepartment < ActiveRecord::Base
  def self.permitted(params)
    fast_content_department_whitelist = [:fast_content_id, :department_id]
    params.permit(fast_content_department: fast_content_department_whitelist)
  end
  
  belongs_to :fast_content
  belongs_to :department
end

# == Schema Information
#
# Table name: industries
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  naics_code     :integer
#  parent_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  naics_code_top :integer
#

# FIXME (cmhobbs+tyreldenison) purge this model
class Industry < ActiveRecord::Base
  def self.permitted(params)
    industry_whitelist = [:naics_code, :parent_id, :title, :naics_code_top]
    params.permit(industry: industry_whitelist)
  end

  validates :title, :uniqueness => true
end

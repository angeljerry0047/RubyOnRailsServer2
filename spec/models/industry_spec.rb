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

require 'spec_helper'

describe Industry do

end

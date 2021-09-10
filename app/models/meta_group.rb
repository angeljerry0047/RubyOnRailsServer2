# == Schema Information
#
# Table name: meta_groups
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#

class MetaGroup < ActiveRecord::Base

  has_many :organizations
end

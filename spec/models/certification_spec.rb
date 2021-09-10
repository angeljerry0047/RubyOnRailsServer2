# == Schema Information
#
# Table name: certifications
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  certification_type_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Certification do
  pending "add some examples to (or delete) #{__FILE__}"
end

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

require 'spec_helper'

describe SupportRequest do
  it 'validates presence of user name' do
    request = SupportRequest.new(email: "user@test.com", description: "request description")

    expect(request).to_not be_valid
    request.errors[:name].length.should be > 0
  end

  it 'validates presence of email address' do
    request = SupportRequest.new(name: "user", description: "request description")

    expect(request).to_not be_valid
    request.errors[:email].length.should be > 0
  end

  it 'validates presence of description' do
    request = SupportRequest.new(name: "user", email: "user@test.com")

    expect(request).to_not be_valid
    request.errors[:description].length.should be > 0
  end
end

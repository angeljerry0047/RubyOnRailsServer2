# == Schema Information
#
# Table name: organizations
#
#  id               :integer          not null, primary key
#  type             :string(255)
#  title            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  description      :text
#  company_size_min :integer
#  company_size_max :integer
#  company_type     :string(255)
#  website          :string(255)
#  industry_id      :integer
#  operating_status :string(255)
#  year_founded     :integer
#  address1         :string(255)
#  address2         :string(255)
#  city             :string(255)
#  state            :string(255)
#  zipcode          :integer
#  oid              :string(255)
#  provider         :string(255)
#  avatar           :string(255)
#  banner           :string(255)
#  active_license   :boolean
#  salesforce_id    :string(255)
#  has_chatter      :boolean
#  user_licenses    :integer
#  int_description  :text
#  domain           :string(255)
#  meta_group_id    :integer
#

require 'spec_helper'

describe Organization do
  it 'spits out company_sizes based on linkedin' do
    expected = ['myself only', '2-10', '11-50', '51-200', '201-500', '501-1000', '1001-5000', '5001-10000', '10001+']
    Organization.company_sizes.should == expected
  end
  
  it 'shows employee_count_range like linkedin does' do
    org = Organization.new(:company_size_min => 10_001, :company_size_max => nil)
    org.employee_count_range.should == '10001+'
  end
  
  it 'throws a record not found error if there is no manager' do
    company = Company.new
    lambda { company.manager }.should raise_error ActiveRecord::RecordNotFound
  end
  
  it 'prints the website_url and forces a http:// on the front if there isnt one' do
    company = Company.new(:website => "zomg.com")
    company.website_url.should == 'http://zomg.com'
  end
  
  it 'prints nothing if there is no website' do
    company = Company.new(:website => nil)
    company.website_url.should == ''
  end
  
  %w[http https].each do |scheme|
    it "does not put #{scheme} in front of a website that already has it" do
      # Technically we should allow for other things but just assume http / https for now lol...
      company = Company.new(:website => "#{scheme}://zomg.com")
      company.website_url.should == "#{scheme}://zomg.com"
    end
  end
end

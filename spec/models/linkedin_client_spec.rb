require 'spec_helper'

describe LinkedinClient do
  let(:response) {
    YAML::load_file(
      Rails.root.join("./spec/fixtures/response_from_linkedin.yml")
    )
  }

  let(:naics_code) {
    response.industries.all.first.code
  }
  
  it 'takes a response and builds a changeset' do
    @organization = FactoryBot.create(:company)
    industry = Industry.where(naics_code: naics_code).first ||
      FactoryBot.create(:industry, naics_code: naics_code)
    
    changeset = LinkedinClient.differences_between(@organization, response)
    

    
    changeset['title'].should == response.name
    changeset['description'].should == response.description
    changeset['company_size_min'].should == 10001
    changeset['company_size_max'].should == nil
    changeset['website'].should == response.website_url
    changeset['company_type'].should == response.company_type.name
    changeset['operating_status'].should == response.status.name
    changeset['year_founded'].should == response.founded_year
    changeset['address1'].should == response.locations.all.first.address.street1
    changeset['address2'].should be_nil
    changeset['city'].should == response.locations.all.first.address.city
    changeset['zipcode'].should == response.locations.all.first.address.postal_code
    changeset['state'].should == response.locations.all.first.address.state
    
    
    changeset['industry_id'].should == industry.id
  end
end
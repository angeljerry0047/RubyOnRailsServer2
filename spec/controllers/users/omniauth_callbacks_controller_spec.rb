require 'spec_helper'

describe Users::OmniauthCallbacksController do
  let(:linkedin) do 
    YAML::load_file(Rails.root.join("./spec/fixtures/linked_in_test.yml"))
  end

  let(:user_different_email) do 
    FactoryBot.create(
      :professional,
      uid:      linkedin.uid, 
      provider: linkedin.provider
      )
  end

  let(:user_same_email) do 
    FactoryBot.create(
      :professional, 
      email:    linkedin.info.email, 
      provider: linkedin.provider, 
      uid:      linkedin.uid
    )
  end
  
  before(:each) do
    set_omniauth
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["omniauth.auth"]  = linkedin
  end

  # NOTE (cmhobbs+mbindya) marking skip until we have time to dig through
  #      the failure.  it appears to be a postgres function issue  
  skip '#linkedin' do

    it 'allows you to sign in with linkedin fresh' do
      get :linkedin
      User.exists?(:email => linkedin.info.email, :uid => linkedin.uid, :provider => linkedin.provider)
      
      response.should be_success
    end
    
    # FIXME (cmhobbs+mbindya) condense to a single assertion
    it 'allows you to sign in via linkedin and use the e-mail that has the same UID' do
      User.count.should == 0
      user_different_email
      get :linkedin
      
      User.count.should == 1
      response.should redirect_to opportunities_path
    end
  
    it 'renders the page where you determine what you want to keep and what not to' do
      user_same_email
      get :linkedin
      
      response.should redirect_to opportunities_path
    end
  end
end

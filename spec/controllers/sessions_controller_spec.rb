require 'spec_helper'

describe SessionsController do
  
  let(:linkedin_auth) { YAML::load_file(Rails.root.join("./spec/fixtures/linked_in_test.yml")) }
  let(:linkedin_uid)  { linkedin_auth.uid.to_s }

  let(:user) { FactoryBot.create(:professional) }

  describe 'POST create' do

    before do
      set_omniauth

      @request.env['devise.mapping']  = Devise.mappings[:user]
      session['devise.linkedin_data'] = linkedin_auth

      # NOTE (cmhobbs) password pulled from user factory
      post :create, :user => { password: "Testtest1", email: user.email }, commit: 'test'
    end

    it "syncs the user's linkedin uid" do
      expect(user.reload.uid).to eq(linkedin_uid)
    end

    it "syncs 'linkedin' as the provider" do
      expect(user.reload.provider).to eq('linkedin')
    end

  end
end

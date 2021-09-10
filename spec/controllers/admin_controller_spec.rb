require 'spec_helper'

describe AdminController do
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:user) { FactoryBot.create(:user) }
  let(:facility) { FactoryBot.create(:facility, id: 1) }

  describe "GET :index" do
    it 'allows admins' do
      facility
      sign_in(admin)
      get :index
      expect(response.status).to eq(200)
    end

    it 'redirects non-admins' do
      facility
      sign_in(user)
      get :index
      expect(response.status).to eq(302)
    end
  end

end
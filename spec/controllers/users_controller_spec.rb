require 'spec_helper'

describe UsersController do
  let(:current_user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET show' do
    it 'redirects unauthenticated user' do
      get :show, id: other_user.id

      response.should redirect_to(new_user_session_path)
    end

    it 'allows authenticated user to view profile' do
      sign_in(current_user)
      get :show, id: other_user.id

      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end

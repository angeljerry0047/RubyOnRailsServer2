require 'spec_helper'

describe RecognitionsController do
  let(:current_user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:badge_type) { BadgeType.create(name: 'Collaborator') }

  describe 'POST create' do
    it 'redirects unauthenticated user' do
      post :create, recognition: { badge_type_id: badge_type.id, user_id: other_user.id }

      response.should redirect_to(new_user_session_path)
    end

    it 'allows authenticated user to award badge' do
      sign_in(current_user)

      expect do
        post :create, recognition: { badge_type_id: badge_type.id, user_id: other_user.id }
      end.to change { other_user.badges.count }

      response.should redirect_to(user_path(other_user))
    end

    it 'handles badge type not being submitted' do
      sign_in(current_user)

      expect do
        post :create, recognition: { user_id: other_user.id }
      end.to_not change { other_user.badges.count }

      response.should redirect_to(new_recognition_path(user_id: other_user.id))
    end
  end
end

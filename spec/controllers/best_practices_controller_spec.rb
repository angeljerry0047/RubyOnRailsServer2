require 'spec_helper'

describe BestPracticesController do
  let(:user) { FactoryBot.create(:user) }
  let(:organization) { FactoryBot.create(:org_with_users) }
  let(:valid_params) do
    { user_id: user.id, title: 'test post', body: 'test body', is_public: true, organization_id: [organization.id],
      ext_link: '', link_title: '' }
  end

  describe 'POST create' do
    it 'saves the best practice' do
      sign_in(user)

      expect do
        post :create, best_practice: valid_params
      end.to change { BestPractice.count }
    end

    it 'adds email notification to background queue when org.members empty' do
      user2 = FactoryBot.create(:user, organization_id: organization.id)
      sign_in(user)

      expect(BestPracticeEmailWorker).to receive(:perform_async)
      post :create, best_practice: valid_params
    end

    it 'adds email notification to background queue when org.members not empty' do
      user2 = FactoryBot.create(:user)
      UserGroup.create(group_id: organization.id, member_id: user2.id, approved: true)
      sign_in(user)

      expect(BestPracticeEmailWorker).to receive(:perform_async)
      post :create, best_practice: valid_params
    end

    it 'adds email to users org notification to background queue when post org id empty' do
      sign_in(user)
      user.organization_id = organization.id
      user.save
      FactoryBot.create(:user, organization_id: organization.id)
      valid_params[:organization_id] = [nil]

      expect(BestPracticeEmailWorker).to receive(:perform_async)
      post :create, best_practice: valid_params
    end
  end
end

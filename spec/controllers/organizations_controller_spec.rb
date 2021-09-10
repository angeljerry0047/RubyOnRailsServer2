# frozen_string_literal: true

require 'spec_helper'

describe OrganizationsController do
  let(:current_user) { FactoryBot.create(:user) }
  let(:organization) { FactoryBot.create(:org_with_users) }

  it 'allows group admin to add users to group' do
    new_member = FactoryBot.create(:professional)
    GroupAdmin.new(group_id: organization.id, admin_id: current_user.id)
    sign_in(current_user)

    expect do
      post :add_users, slug: organization.slug, user_ids: [new_member.id]
    end.to change { organization.members.count }

    response.should redirect_to(action: :show,  slug: organization.slug)
  end

  it 'handles adding users to group when no users are selected' do
    GroupAdmin.new(group_id: organization.id, admin_id: current_user)
    sign_in(current_user)

    expect do
      post :add_users, slug: organization.slug
    end.to_not change { organization.members.count }

    response.should redirect_to(action: :find_users,  slug: organization.slug)
  end

  describe 'GET show' do
    it 'redirects unauthenticated user' do
      get :show, slug: organization.slug

      response.should redirect_to(new_user_session_path)
    end

    it 'allows authorized user to view group' do
      sign_in(current_user)
      UserGroup.create(member_id: current_user.id, group_id: organization.id, approved: true)
      get :show, slug: organization.slug

      expect(response).to render_template(:show)
    end
  end
end

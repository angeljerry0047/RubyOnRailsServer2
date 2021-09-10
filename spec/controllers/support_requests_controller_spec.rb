require 'spec_helper'

describe SupportRequestsController do

  describe 'GET new' do
    it 'allows unverified user access to submit request' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    it 'allows unverified user to submit support request' do
      expect {
        post :create, support_request: { name: "user", email: "user@test.com", description: "issue description" }
      }.to change { SupportRequest.count }
    end

    it 'adds email notification to background queue' do
      expect {
        post :create, support_request: { name: "user", email: "user@test.com", description: "issue description" }
      }.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }
    end
  end
end

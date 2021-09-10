require 'spec_helper'

describe BestPracticeEmailWorker do
  describe '.perform' do
    let(:best_practice) { FactoryBot.create(:best_practice) }

    it 'Queues up the emails to be sent' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      user_list = [user1.id, user2.id]

      expect do
        BestPracticeEmailWorker.new.perform(best_practice.id, user_list)
      end.to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(2)
    end

    it 'Does not mail user with mute_notifications set to true' do
      user1 = FactoryBot.create(:user, mute_notifications: true)
      user_list = [user1.id]

      expect do
        BestPracticeEmailWorker.new.perform(best_practice.id, user_list)
      end.to_not change { Sidekiq::Extensions::DelayedMailer.jobs.size }
    end
  end
end

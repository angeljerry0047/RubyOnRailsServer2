require 'spec_helper'

describe EmailWorker do

  let(:johnny_nomail) { mock_model(User, mute_notifications: false) }
  let(:jane_getmail)  { mock_model(User, mute_notifications: false) }
  let(:users)         { [johnny_nomail, jane_getmail] }

  let(:email_worker)  { EmailWorker.new }

  before do
    User.stub(:receives_email) { users }
    BestPractice.stub(:find)   { double('best_practice', user: johnny_nomail) }

    email_worker.stub(:notify)
  end

  describe '#perform' do

    it 'does not notify the User associated with the given BestPractice' do
      expect(email_worker).to receive(:notify).once
      email_worker.perform('42')
    end
  end
  
end

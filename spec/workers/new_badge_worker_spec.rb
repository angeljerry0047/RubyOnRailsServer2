require 'spec_helper'

describe NewBadgeWorker do 

  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:badge)     { mock_model(Badge, user: author)}

    before do
      Badge.stub(:find)            { badge }
      User.stub(:receives_email)   { [recipient] } 
      BadgeMailer.stub(:new_badge) { Mail::Message.new }
    end

    it 'calls BadgeMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewBadgeWorker.perform(2)
    end
  end

end

require 'spec_helper'

describe NewInsightWorker do

  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:insight)   { mock_model(BestPractice, user: author) }

    before do
      BestPractice.stub(:find)         { insight }
      User.stub(:receives_email)       { [recipient] }
      InsightMailer.stub(:new_insight) { Mail::Message.new }
    end

    it 'calls InsightMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewInsightWorker.perform(42)
    end
  end

end

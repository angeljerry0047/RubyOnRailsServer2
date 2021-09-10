require 'spec_helper'

describe NewFastContentWorker do

  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:member)    { mock_model(FastContent, user: author) }

    before do
      User.stub(:find)                 { member }
      FastContent.stub(:find)          { member }
      User.stub(:receives_email)       { [recipient] } 
      FastContentMailer.stub(:new_fastcontent) { Mail::Message.new }
    end

    it 'calls fastContentMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewFastContentWorker.perform(4,5)
    end
  end

end
require 'spec_helper'

describe NewInviteWorker do

  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:invite)    { mock_model(Invite, user: author) }
   
    before do
      Invite.stub(:find)             { invite }
      User.stub(:receives_email)     { [recipient] } 
      InviteMailer.stub(:new_invite) { Mail::Message.new }
    end

    it 'sends InviteMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewInviteWorker.perform(7)
    end
  end

end

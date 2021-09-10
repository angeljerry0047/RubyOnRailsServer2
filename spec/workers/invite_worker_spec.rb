require 'spec_helper'

describe InviteWorker do
  
  let(:worker)          { InviteWorker.new }
  let(:linkedin_client) { double('linkedin_client') }
  let(:invite)          { FactoryBot.build(:invite) }
  let(:user)            { FactoryBot.create(:user) }

  before do
    linkedin_client.stub(send_message: true)
    user.stub(to_linkedin_client: linkedin_client)
    invite.user = user
    invite.save
  end
 
  it 'sends an invite from a given invite id' do
    linkedin_client.should_receive('send_message')
    worker.send_message_to(invite)
  end

  it 'performs only if completed_at is nil' do
    worker.stub(:send_message_to) { true }

    allow(Invite).to receive(:find).and_return(invite)
    worker.perform(invite.id)

    reloaded_time = invite.reload.completed_at
    expect(invite.completed_at).to_not be(nil)
  end
end

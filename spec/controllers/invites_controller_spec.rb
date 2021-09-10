require 'spec_helper'

describe InvitesController do
  let(:current_user) { FactoryBot.create(:user) }
  
  it 'creates a new invite to be sent out' do
    Invite.count.should == 0
    
    payload = {:id => '123', :first_name => "feep", :last_name => "foop"}
    sign_in(current_user)
    post :create, :connection => payload
    
    Invite.count.should == 1
    
    Invite.last.oid.should == '123'
  end
end
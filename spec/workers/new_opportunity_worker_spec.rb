require 'spec_helper'

describe NewOpportunityWorker do

  describe '.perform' do

    let(:author)        { mock_model(User) }
    let(:recipient)     { mock_model(User) }
    let(:opportunity)   { mock_model(Opportunity, user: author) }

    before do
      Opportunity.stub(:find)      { opportunity }
      User.stub(:receives_email)   { [recipient] } 
      OpportunityMailer.stub(:new_opportunity) { Mail::Message.new }
    end
        
    it 'calls OpportunityMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewOpportunityWorker.perform(6)
    end
  end

end


require 'spec_helper'

describe NewAnswerWorker do

  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:comment)   { mock_model(Inquiry, user: author) }

    before do
      Inquiry.stub(:find)            { comment }
      Comment.stub(:find)            { comment }
      User.stub(:receives_email)     { [recipient] } 
      AnswerMailer.stub(:new_answer) { Mail::Message.new }
    end

    it 'calls AnswerMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewAnswerWorker.perform(58,5)
    end
  end
  
end

require 'spec_helper'

describe NewQuestionWorker do
  
  describe '.perform' do

    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:question)  { mock_model(Inquiry, user: author) }

    before do
      Inquiry.stub(:find)                { question }
      User.stub(:receives_email)         { [recipient] } 
      QuestionMailer.stub(:new_question) { Mail::Message.new }
    end

    it 'calls QuestionMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewQuestionWorker.perform(20)
    end
  end
  
end
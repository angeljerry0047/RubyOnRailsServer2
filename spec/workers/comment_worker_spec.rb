require 'spec_helper'

describe NewCommentWorker do
 
  describe '.perform' do
    let(:author)    { mock_model(User) }
    let(:recipient) { mock_model(User) }
    let(:comment)   { mock_model(Inquiry, user: author) }

    before do
      BestPractice.stub(:find)         { comment }
      Comment.stub(:find)              { comment }
      User.stub(:receives_email)       { [recipient] } 
      CommentMailer.stub(:new_comment) { Mail::Message.new }
    end

    it 'calls CommentMailer for each valid recipient' do
      expect_any_instance_of(Mail::Message).to receive(:deliver_now).once
      NewCommentWorker.perform(10,5)
    end
  end
  
end

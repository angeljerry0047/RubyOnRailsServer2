require 'spec_helper'

describe QuestionWorker do

  let(:johnny_nomail) { mock_model(User, mute_notifications: false) }
  let(:jane_getmail)  { mock_model(User, mute_notifications: false) }
  let(:users)         { [johnny_nomail, jane_getmail] }

  let(:question_worker) { QuestionWorker.new }

  before do
    User.stub(:receives_email) { users }
    Inquiry.stub(:find)        { double('inquiry', user: johnny_nomail) }

    question_worker.stub(:notify)
  end

  describe '#perform' do

    it 'does not notify the User associated with the given Inquiry' do
      expect(question_worker).to receive(:notify).once
      question_worker.perform('42')
    end

  end
end

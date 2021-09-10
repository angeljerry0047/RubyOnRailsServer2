require 'spec_helper'

describe AnswerWorker do

  describe '.perform' do

    let(:fake_notifier) { double("notifier", new_answer_email: fake_message) }
    let(:fake_message)  { double(Mail::Message, deliver!: nil) }
    let(:answer)        { double("AnswerWorker", perform: nil) } 

    before do
      Notifier.stub(:delay)          { fake_notifier }
    end

    pending 'delivers an email to the user' do
      expect(fake_message).to receive(:deliver!).once
      answer.perform(58,5)

    end
  end
  
end

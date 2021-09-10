require 'spec_helper'

describe InviteMailer do 

  let(:user) do
    mock_model(
      User,
      name: "Pete Sampras",
      email: "psampras@lol.com"
    )
  end

  let(:message) { InviteMailer.new_invite(user) }

  describe '#new_invite' do

    it 'renders a multipart message' do
      expect(message.content_type).to match("multipart/alternative")
    end

    it 'renders the to address' do
      recipient = message.to
      expect(recipient).to eq([user.email])
    end

    it 'renders the from address' do
      sender = message.from
      expect(sender).to eq(["notification@serve2perform.com"])
    end

    it 'renders the subject' do
      subject_text = "You've been invited to join serve2perform!"
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end
    end

    context 'text message body' do
      let(:body) { message.text_part.body }
      it_behaves_like 'a valid message body'
      end

    context 'html messsage body' do
      let(:body) { message.html_part.body }
      it_behaves_like 'a valid message body'
    end
  
  end
end  
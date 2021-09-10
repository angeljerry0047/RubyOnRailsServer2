require 'spec_helper'

describe AnswerMailer do 

  let(:user) do
    mock_model(
      User,
      name: "Pete Sampras",
      email: "psampras@lol.com"
    )
  end

  let(:inquiry) do
    mock_model(
      Inquiry,
      id: 2,
      category: "IT"
    )
  end

  let(:message) { AnswerMailer.new_answer(user, inquiry) }

  describe '#new_answer' do

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
      subject_text = "I have posted an answer on the IT question on serve2perform"
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end

      it 'includes the answer ' do
        expect(body).to match(inquiry.category)
      end

      it "includes a link to the user's profile" do
        url = "https://serve2mentor.com/inquiries/#{inquiry.id}"
        expect(body).to match(url)
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
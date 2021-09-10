require 'spec_helper'

describe FastContentMailer do 
  let(:organization) do
    mock_model(
      Organization,
      title: "GPA"
    )
  end

  let(:user) do
    mock_model(
      User,
      name:  "Roger Fry",
      email: "rfrye@lpl.com",
      organization: organization
    )
  end

  let(:fast_content) do
    mock_model(
      FastContent, 
      category_id: 2,
      topic: "Public Speaking"
    )
  end

  let(:message) { FastContentMailer.new_fastcontent(user, fast_content) }

  describe '#new_fastcontent' do

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
      subject_text = "New Fast Content has been posted on serve2perform."
      
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end

      it 'includes the fastcontent topic' do
        expect(body).to match(fast_content.topic)
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
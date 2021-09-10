require 'spec_helper'

describe InsightMailer do
  
  let(:user) do
    mock_model(
      User,
      name:  "Jane Doe",
      email: "jane@example.com"
    )
  end

  let(:insight) do
    mock_model(
      BestPractice, 
      id: 42,
      category: "Technology"
    )
  end

  let(:message) { InsightMailer.new_insight(user, insight) }

  describe '#new_insight' do

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
      subject_text = "Check out my Technology idea on serve2perform"
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end

      it 'includes the insight category' do
        expect(body).to match(insight.category)
      end

      it 'includes a link to the insight' do
        url = "https://serve2mentor.com/best_practices/#{insight.id}"
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

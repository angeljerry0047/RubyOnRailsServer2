require 'spec_helper'

describe BadgeMailer do

  let(:user) do
    mock_model(
      User, 
      id:    18, 
      name:  'Perrywinkle Jones',
      email: 'p.winkle@example.com'
    )  
  end

  let(:badge_type) { mock_model(BadgeType, name: 'Allstar') }
  let(:badge)      { mock_model(Badge, badge_type: badge_type) }
  let(:message) { BadgeMailer.new_badge(user, badge) }

  describe '#new_badge' do

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
      subject_text = "You have been awarded the #{badge.badge_type.name} badge on serve2perform!"
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end

      it 'includes the badge name' do
        expect(body).to match(badge_type.name)
      end

      it "includes the user's name" do
        expect(body).to match(user.name)
      end

      it "includes a link to the user's profile" do
        url = "http://serve2mentor.com/users/#{user.id}"
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
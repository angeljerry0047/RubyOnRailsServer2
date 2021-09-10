require 'spec_helper'

describe OpportunityMailer do
  
   let(:user) do
    mock_model(
      User, 
      name:  "Perrywinkle Jones",
      email: "pwinkle@example.com"
    )  
  end

  let(:opportunity) do 
   mock_model(
     Opportunity, 
     opportunity_category_id: 4,
     title: "Intern" 
     )
  end

  let(:message) { OpportunityMailer.new_opportunity(user, opportunity) }

  describe '#new_opportunity' do

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
      subject_text = "I just posted a Intern opportunity on serve2perform."
      expect(message.subject).to eq(subject_text)
    end

    shared_examples "a valid message body" do
      it 'includes the user name' do
        expect(body).to match(user.name)
      end

      it 'includes the answer ' do
        expect(body).to match(opportunity.title)
      end

      it "includes a link to the opportunity category" do
        url = "https://serve2mentor.com/opportunities/#{opportunity.opportunity_category_id}"
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

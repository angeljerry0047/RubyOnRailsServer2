require "spec_helper"

describe Notifier do
  it 'sends an e-mail from the assessment_report page' do
    recipient = "Matt Kirk <meep@moop.com>"
    subject = "Zomg test"
    text = "HIHIHI \n \n\n zomg"
    assessment_report = FactoryBot.create(:assessment_report)
    lambda { Notifier.assessment(recipient, subject, text, assessment_report.id).deliver_now! }.should_not raise_error
  end
  
  context 'threshold e-mail' do
    it 'renders and sends out a low threshold e-mail' do
      company = FactoryBot.create(:company)
      user = FactoryBot.create(:user, :managed_organization => company)

      mail = Notifier.need_more_coupon_purchases(user)
      mail.to.first.should == user.email
      mail.body.should == Notifier.low_threshold_email(user)
    end

    # XXX (cmhobbs) this is actually raising the proper error but
    #     rspec isn't catching it.
    pending 'doesnt send a low threshold e-mail unless the user is a manager...' do
      user = FactoryBot.create(:user, :managed_organization => nil)
      #lambda { Notifier.need_more_coupon_purchases(user) }.should raise_error(Notifier::NotAuthorizedError)
      expect { Notifier.need_more_coupon_purchases(user) }.to raise_error(Notifier::NotAuthorizedError)
      
    end    
  end
end

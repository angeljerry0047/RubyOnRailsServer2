class OpportunityMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"
 
  def new_opportunity(user, opportunity)
    @user        = user
    @opportunity = opportunity

    mail(
      to:       user.email,
      subject:  "I just posted a #{@opportunity.title} opportunity on SERVE2MENTOR."
    )
  end
  
end

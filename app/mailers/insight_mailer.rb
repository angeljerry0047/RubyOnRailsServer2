class InsightMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"
 
  def new_insight(user, insight)
    @user    = user
    @insight = insight

    mail(
       to:      user.email,
       subject: "Check out my #{insight.category} idea on SERVE2MENTOR"
    )
  end
   
end

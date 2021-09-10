class InviteMailer< ActionMailer::Base
  default from: "notification@serve2perform.com"

  def new_invite(user)
    @user = user
    
    mail(
      to:       user.email,
      subject:  "You've been invited to join SERVE2MENTOR!" 
    )
  end

end

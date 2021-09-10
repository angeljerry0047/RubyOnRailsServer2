class CommentMailer <ActionMailer::Base
  default from: "notification@serve2perform.com"

  def new_comment(user, best_practice)
    @user          = user
    @best_practice = best_practice
        
    mail(
      to:       user.email,
      subject:  "Check out my comment on the #{@best_practice.category} idea on SERVE2MENTOR"
    )
  end

end
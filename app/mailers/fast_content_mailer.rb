class FastContentMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"

  def new_fastcontent(user,fast_content)
    @user         = user
    @fast_content = fast_content

    mail(
       to:      user.email,
       subject: "New Fast Content has been posted on SERVE2MENTOR."
    )
  end

end

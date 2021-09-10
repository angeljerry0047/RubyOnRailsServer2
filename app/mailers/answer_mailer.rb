class AnswerMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"

  def new_answer(user, inquiry)
    @user    = user
    @inquiry = inquiry

    mail(
      to:       user.email,
      subject:  "I have posted an answer on the #{@inquiry.category} question on SERVE2MENTOR"
    )
  end

end
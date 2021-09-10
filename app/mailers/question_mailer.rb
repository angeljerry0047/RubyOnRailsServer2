class QuestionMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"
 
  def new_question(user, question)
    @user     = user
    @question = question

    mail(
      to:      user.email,
      subject: "Check out my #{@question.category} idea on SERVE2MENTOR"
    )
  end
  
end

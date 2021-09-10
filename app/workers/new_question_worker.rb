class NewQuestionWorker
  @queue = :default

  def self.perform(question_id)
    question = Inquiry.find(question_id)

    User.receives_email.each do |user|
      unless user == question.user
        QuestionMailer.new_question(user, question).deliver_now
      end
    end
  end
  
end
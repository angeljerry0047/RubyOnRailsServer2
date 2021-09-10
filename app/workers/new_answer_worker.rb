class NewAnswerWorker
  @queue = :default

  def self.perform(inquiry_id, comment_id)
    inquiry = Inquiry.find(inquiry_id)
    comment = Comment.find(comment_id)

    User.receives_email.each do |user|
      AnswerMailer.new_answer(user, inquiry, comment).deliver_now
    end
  end

end

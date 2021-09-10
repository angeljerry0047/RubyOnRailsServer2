class NewCommentWorker
  @queue = :default

  def self.perform(best_practice_id, comment_id)
    best_practice = BestPractice.find(best_practice_id)
    comment       = Comment.find(comment_id)

    User.receives_email.each do |user|
      CommentMailer.new_comment(user, best_practice, comment).deliver_now
    end
  end

end

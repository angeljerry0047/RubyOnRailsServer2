class CommentWorker
  include Sidekiq::Worker
 
  def perform(comment_id)
    comment = Comment.find(comment_id)
    best_practice = BestPractice.find(comment.commentable_id)
    
    recipients(best_practice.id).each do |member|
      Notifier.delay.new_comment_email(member, best_practice, comment)
    end
  end

  def recipients(best_practice_id)
    best_practice = BestPractice.find(best_practice_id)
    user  = best_practice.user

    [].tap do | interested_users |
      best_practice.comments.each do | comment | 
       interested_users << comment.user
      end
    
      interested_users << user  
    end.flatten.uniq
  
  end

end

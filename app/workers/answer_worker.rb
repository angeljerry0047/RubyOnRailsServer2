class AnswerWorker
  include Sidekiq::Worker
 
  def perform(comment_id)
    comment = Comment.find(comment_id)
    inquiry = Inquiry.find(comment.commentable_id)
    
    recipients(inquiry.id).each do |member|
      Notifier.delay.new_answer_email(member, inquiry, comment)
    end
  end
  
  def recipients(inquiry_id)
    inquiry = Inquiry.find(inquiry_id)
    user  = inquiry.user

    [].tap do | interested_users |
      inquiry.comments.each do | comment | 
       interested_users << comment.user
      end

      interested_users << user
    end.flatten.uniq
   
  end

end

class QuestionWorker
  include Sidekiq::Worker
 
  def perform(inquiry_id)
    inquiry = Inquiry.find(inquiry_id)

    User.receives_email.each do |user|
      notify(user, inquiry) unless user == inquiry.user
    end
  end

  def notify(user, inquiry)
    Notifier.delay.new_inquiry_email(user, inquiry)
  end

end

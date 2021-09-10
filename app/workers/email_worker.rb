# FIXME (cmhobbs) rename this class to reflect its purpose
class EmailWorker
  include Sidekiq::Worker
 
  def perform(best_practice_id)
    best_practice = BestPractice.find(best_practice_id)

    User.receives_email.each do |user|
      notify(user, best_practice) unless user == best_practice.user
    end
  end

  def notify(user, best_practice)
    Notifier.delay.new_best_practice_email(user, best_practice)
  end

end

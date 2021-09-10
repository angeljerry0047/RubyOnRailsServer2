class BestPracticeEmailWorker
  include Sidekiq::Worker

  def perform(best_practice_id, user_id_list)
    best_practice = BestPractice.find(best_practice_id)
    users = User.where(id: user_id_list)

    users.each do |user|
      unless user.mute_notifications
        Notifier.delay.new_best_practice_email(user, best_practice)
      end
    end
  end
end
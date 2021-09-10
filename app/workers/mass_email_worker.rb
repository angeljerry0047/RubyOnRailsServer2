class MassEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
  	sender = User.find(user_id)
  	#member = User.find(user_id)
    User.receives_email.each do |member|
      Notifier.delay.new_mass_email(member, sender)
    end
  end
  
end
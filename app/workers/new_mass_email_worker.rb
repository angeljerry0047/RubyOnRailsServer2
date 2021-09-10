class NewMassEmailWorker
  @queue = :default

  def self.perform(user_id)
    sender = User.find(user_id)
   
    User.receives_email.each do |user|
      MassEmailMailer.new_mass_email(user, sender).deliver_now
    end
  end

end

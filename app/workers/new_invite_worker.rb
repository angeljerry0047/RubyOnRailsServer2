class NewInviteWorker
  @queue = :default

  def self.perform(invite_id)
    invite = Invite.find(invite_id)

    User.receives_email.each do |user|
      InviteMailer.new_invite(user, invite).deliver_now
    end
  end

end
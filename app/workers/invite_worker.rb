class InviteWorker
  include Sidekiq::Worker
  
  # FIXME (cmhobbs) this could really use a constructor so we don't
  #       have to pass invite around everywhere
  def perform(invite_id)
    invite = Invite.find(invite_id)
    deliver_and_update(invite) if invite.completed_at.nil?
  end
  
  def send_message_to(invite)
    message = build_message(invite)
    client  = invite.user.to_linkedin_client

    client.send_message(
      message.fetch(:subject),
      message.fetch(:body),
      Array(invite.oid)
    )
  end

  private

  def deliver_and_update(invite)
    send_message_to(invite)
    invite.completed_at = Time.now
    invite.save!
  end

  # FIXME (cmhobbs) move all this nonsense to a proper mailer
  def build_message(invite)
    { 
      subject:  "#{invite.user.name} wants to invite you to myserve2eprform.com",
      body:     "Hello #{invite.first_name},\n\nJoin me at myserve2eprform.com and power your job performance through connections. Become a member today and grow your learning resources immediately and begin to connect, learn, and practice a selection of professional skills.Join us here, http://myserve2eprform.com.\n\nThanks,\n\n#{invite.user.name}\nserve2perform Member\n"
    }
  end

end

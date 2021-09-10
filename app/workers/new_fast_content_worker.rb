class NewFastContentWorker
  @queue = :default

  def self.perform(member_id, fast_content_id) 
    member       = User.find(member_id)
    fast_content = FastContent.find(fast_content_id)
    
    # XXX (cmhobbs) make sure this isn't another email spewing loop.
    #     see FastContentWorker for details.
    User.receives_email.each do |user|
      FastContentMailer.new_fastcontent(user, member,fast_content).deliver_now
    end
  end

end

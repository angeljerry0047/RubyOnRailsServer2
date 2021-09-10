class FastContentWorker
  include Sidekiq::Worker

  def perform(fast_content_id)
    fast_content = FastContent.find(fast_content_id)

    user_set(fast_content).each do |member|
      notify(member, fast_content) unless fast_content.user == member
    end
  end
  
  def user_set(fast_content)
    fast_content.organization.users.receives_email
  end

  def notify(member, fast_content)
    Notifier.delay.new_fast_content_email(member, fast_content)
  end

end

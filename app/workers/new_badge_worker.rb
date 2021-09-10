class NewBadgeWorker
  @queue = :default

  def self.perform(badge_id)
    badge = Badge.find(badge_id)

    User.receives_email.each do |user|
      BadgeMailer.new_badge(user, badge).deliver_now
    end
  end

end

class BadgeWorker
  include Sidekiq::Worker
 
  def perform(badge_id)
    badge = Badge.find(badge_id)

    recipients(badge_id).each do |member|
      Notifier.delay.new_mass_badge_email(member, badge)
    end
  end

  def recipients(badge_id)
    badge = Badge.find(badge_id)
    user  = badge.user

    #user.related_groups_users.reject { |recipient| recipient.mute_notifications == true }
    User.where(:organization_id => user.organization_id).reject { |recipient| recipient.mute_notifications == true }
  end

end

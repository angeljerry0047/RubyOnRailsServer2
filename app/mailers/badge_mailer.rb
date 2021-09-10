class BadgeMailer < ActionMailer::Base
  default from: "notification@serve2perform.com"
 
  def new_badge(user, badge)
    @user_id    = user.id
    @user_name  = user.name
    @badge_name = badge.badge_type.name

    mail(
      to:       user.email,
      subject:  "You have been awarded the #{@badge_name} badge on SERVE2MENTOR!"
    )
  end

end
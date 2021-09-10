# FIXME (cmhobbs) refactor.
module Points
  def give_them_an_ideator_point(user)
    @point = Point.new
    @point.user_id = user.id 
    @point.badge_type_id = 1
    @point.year = Time.now.year
    @oldbadge = Badge.where(:user_id => user.id).where(:badge_type_id => 1).where(:year => Time.now.year)
    if @oldbadge.empty?
      if @point.save!
        if Point.ideator.where(:user_id => user.id).count < @point.badge_type.points_req
          #Notifier.delay.new_point_email(user, @point)
        end
        if Point.ideator.where(:user_id => user.id).count == @point.badge_type.points_req
          @badge = Badge.new
          @badge.user_id = user.id
          @badge.badge_type_id = 1
          @badge.year = Time.now.year
          @badge.save!
          Notifier.delay.new_badge_email(user, @badge)
          BadgeWorker.perform_async(@badge.id)
        end
      end
    end
  end

  def give_them_an_mentor_point(user)
    @point = Point.new
    @point.user_id = user.id 
    @point.badge_type_id = 2
    @point.year = Time.now.year
    @oldbadge = Badge.where(:user_id => user.id).where(:badge_type_id => 2).where(:year => Time.now.year)
    if @oldbadge.empty?
      if @point.save!
        if Point.mentor.where(:user_id => user.id).count < @point.badge_type.points_req
          #Notifier.delay.new_point_email(user, @point)
        end
        if Point.mentor.where(:user_id => user.id).count == @point.badge_type.points_req
          @badge = Badge.new
          @badge.user_id = user.id
          @badge.badge_type_id = 2
          @badge.year = Time.now.year
          @badge.save!
          Notifier.delay.new_badge_email(user, @badge)
          BadgeWorker.perform_async(@badge.id)
        end
      end
    end
  end

  def give_them_an_teacher_point(user)
    @point = Point.new
    @point.user_id = user.id 
    @point.badge_type_id = 3
    @point.year = Time.now.year
    @oldbadge = Badge.where(:user_id => user.id).where(:badge_type_id => 3).where(:year => Time.now.year)
    if @oldbadge.empty?
      if @point.save!
        if Point.teacher.where(:user_id => user.id).count < @point.badge_type.points_req
          #Notifier.delay.new_point_email(user, @point)
        end
        if Point.teacher.where(:user_id => user.id).count == @point.badge_type.points_req
          @badge = Badge.new
          @badge.user_id = user.id
          @badge.badge_type_id = 3
          @badge.year = Time.now.year
          @badge.save!
          Notifier.delay.new_badge_email(user, @badge)
          BadgeWorker.perform_async(@badge.id)
        end
      end
    end
  end

  def give_them_an_stakeholder_point(user)
    @point = Point.new
    @point.user_id = user.id 
    @point.badge_type_id = 4
    @point.year = Time.now.year
    @oldbadge = Badge.where(:user_id => user.id).where(:badge_type_id => 4).where(:year => Time.now.year)
    if @oldbadge.empty?
      if @point.save!
        #Notifier.delay.new_point_email(user, @point)
        if Point.stakeholder.where(:user_id => user.id).count == @point.badge_type.points_req
          @badge = Badge.new
          @badge.user_id = user.id
          @badge.badge_type_id = 4
          @badge.year = Time.now.year
          @badge.save!
          Notifier.delay.new_badge_email(user, @badge)
          BadgeWorker.perform_async(@badge.id)
        end
      end
    end
  end

  def give_them_an_collaborator_point(user)
    @point = Point.new
    @point.user_id = user.id 
    @point.badge_type_id = 6
    @point.year = Time.now.year
    @oldbadge = Badge.where(:user_id => user.id).where(:badge_type_id => 6).where(:year => Time.now.year)
    if @oldbadge.empty?
      if @point.save!
        if Point.collaborator.where(:user_id => user.id).count < @point.badge_type.points_req
          #Notifier.delay.new_point_email(user, @point)
        end
        if Point.collaborator.where(:user_id => user.id).count == @point.badge_type.points_req
          @badge = Badge.new
          @badge.user_id = user.id
          @badge.badge_type_id = 6
          @badge.year = Time.now.year
          @badge.save!
          Notifier.delay.new_badge_email(user, @badge)
          BadgeWorker.perform_async(@badge.id)
        end
      end
    end
  end

end

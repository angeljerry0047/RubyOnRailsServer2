class ChangeMeetingTimeTypeOnMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :meeting_time, :string
  end
end

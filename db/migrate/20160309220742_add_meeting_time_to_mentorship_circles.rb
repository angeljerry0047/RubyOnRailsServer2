class AddMeetingTimeToMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :meeting_time, :datetime
  end
end

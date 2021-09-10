class RemoveStartAndEndTimeFromMentorshipCircles < ActiveRecord::Migration
  def change
    remove_column :mentorship_circles, :start_time
    remove_column :mentorship_circles, :end_time
  end
end

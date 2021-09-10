class AddNumsessionsToMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :numsessions, :integer
  end
end

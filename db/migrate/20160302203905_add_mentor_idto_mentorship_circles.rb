class AddMentorIdtoMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :mentor_id, :integer
  end
end

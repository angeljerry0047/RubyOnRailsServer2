class AddMctypeToMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :mctype, :string
  end
end

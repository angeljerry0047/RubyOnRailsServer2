class AddUserIdtoMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :user_id, :integer
  end
end

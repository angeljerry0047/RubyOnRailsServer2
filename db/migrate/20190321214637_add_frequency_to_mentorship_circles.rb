class AddFrequencyToMentorshipCircles < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :frequency, :string
  end
end

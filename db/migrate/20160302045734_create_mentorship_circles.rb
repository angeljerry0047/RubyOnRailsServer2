class CreateMentorshipCircles < ActiveRecord::Migration
  def change
    create_table :mentorship_circles do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :start_time
      t.string :end_time
      t.integer :min_mentees
      t.integer :max_mentees
      t.text :expectations
      t.string :location_option
      t.text :location

      t.timestamps
    end
  end
end

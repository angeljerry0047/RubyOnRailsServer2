class CreateMentorshipCirclesUsers < ActiveRecord::Migration
  def change
    create_table :mentorship_circles_users, id: false do |t|
      t.belongs_to :mentorship_circle, index: true
      t.belongs_to :user, index: true
    end
  end
end

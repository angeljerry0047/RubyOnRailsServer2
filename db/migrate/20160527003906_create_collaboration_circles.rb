class CreateCollaborationCircles < ActiveRecord::Migration

  def change
    create_table :collaboration_circles do |t|
      t.string   :title
      t.text     :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer  :min_attendees
      t.integer  :max_attendees
      t.text     :expectations
      t.string   :location_option
      t.text     :location
      t.integer  :organization_id
      t.integer  :user_id
      t.string   :meeting_time

      t.timestamps
    end
  end
end

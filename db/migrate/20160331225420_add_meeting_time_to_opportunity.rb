class AddMeetingTimeToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :meeting_time, :string
  end
end

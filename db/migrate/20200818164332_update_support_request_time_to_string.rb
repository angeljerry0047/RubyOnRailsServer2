class UpdateSupportRequestTimeToString < ActiveRecord::Migration
  def up
    change_column :support_requests, :issue_time, :string
  end

  def down
    change_column :support_requests, :issue_time, :datetime
  end
end

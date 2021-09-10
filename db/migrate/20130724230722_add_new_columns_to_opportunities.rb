class AddNewColumnsToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :category, :string
    add_column :opportunities, :learning_objectives, :text
    add_column :opportunities, :start_date, :datetime
    add_column :opportunities, :deadline_date, :datetime
    add_column :opportunities, :start_time, :string
    add_column :opportunities, :end_time, :string
    add_column :opportunities, :max_students, :integer
    add_column :opportunities, :min_students, :integer
    add_column :opportunities, :facility_id, :integer
  end
end

class AddColumnsToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :min_hour, :integer
    add_column :opportunities, :max_hour, :integer
  end
end

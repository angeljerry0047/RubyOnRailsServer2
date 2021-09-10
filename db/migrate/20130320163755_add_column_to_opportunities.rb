class AddColumnToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :description, :text
  end
end

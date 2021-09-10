class AddColumnToOpportunities2 < ActiveRecord::Migration
  def change
    add_column :opportunities, :quantity, :integer
  end
end

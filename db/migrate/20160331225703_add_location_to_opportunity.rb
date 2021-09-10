class AddLocationToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :location, :text
  end
end

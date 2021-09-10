class AddOwnerIdToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :owner_id, :integer
  end
end

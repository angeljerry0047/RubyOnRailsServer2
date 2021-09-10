class AddingManagedOrganizationIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :managed_organization_id, :integer
    add_index :users, :managed_organization_id
  end

  def down
    remove_column :users, :managed_organization_id
  end
end

class AddOrgIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :oid, :string
    add_column :organizations, :provider, :string
  end
end

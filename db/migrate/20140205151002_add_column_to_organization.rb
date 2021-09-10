class AddColumnToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :active_license, :boolean
  end
end

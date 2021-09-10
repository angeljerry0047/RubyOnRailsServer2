class AddSalesforceToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :salesforce_id, :string
    add_column :organizations, :has_chatter, :boolean
  end
end

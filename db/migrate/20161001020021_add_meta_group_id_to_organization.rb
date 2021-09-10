class AddMetaGroupIdToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :meta_group_id, :integer
  end
end

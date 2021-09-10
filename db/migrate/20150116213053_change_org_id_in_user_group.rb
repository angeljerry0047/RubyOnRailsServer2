class ChangeOrgIdInUserGroup < ActiveRecord::Migration
  def change
    rename_column :user_groups, :organization_id, :group_id
  end
end

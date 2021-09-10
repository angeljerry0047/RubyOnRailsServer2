class AddApprovedToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :approved, :boolean, :default => false
  end
end

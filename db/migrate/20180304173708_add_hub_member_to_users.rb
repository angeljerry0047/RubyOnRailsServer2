class AddHubMemberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hub_member, :boolean
  end
end

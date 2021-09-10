class CreateGroupAdmins < ActiveRecord::Migration
  def change
    create_table :group_admins do |t|
      t.integer :group_id
      t.integer :admin_id
    end
  end
end

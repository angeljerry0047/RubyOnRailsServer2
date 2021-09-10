class UserGroup < ActiveRecord::Migration
  def change
  	create_table :user_groups  do |t|
  		t.integer :organization_id
  		t.integer :member_id
  	end
  end
end

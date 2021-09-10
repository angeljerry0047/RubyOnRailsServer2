class AddingApprovedToPacMember < ActiveRecord::Migration
  def up
  	add_column :pac_members, :approved, :boolean 
  end

  def down
  	remove_column :pac_members, :approved, :boolean 
  end
end

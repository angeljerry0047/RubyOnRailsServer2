class CreatePacMembers < ActiveRecord::Migration
  def change
    create_table :pac_members do |t|
      t.integer :member_id
      t.integer :pac_id

      t.timestamps
    end
  end
end

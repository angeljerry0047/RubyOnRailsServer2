class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.integer :position_id

      t.timestamps
    end
    
    add_index :applications, :user_id
    add_index :applications, :position_id
  end
end

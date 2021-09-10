class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :oid
      t.string :first_name
      t.string :last_name
      t.string :provider
      t.datetime :completed_at

      t.timestamps
    end
    
    add_index :invites, :oid
  end
end

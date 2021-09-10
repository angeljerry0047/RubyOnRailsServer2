class CreatePassions < ActiveRecord::Migration
  def change
    create_table :passions do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    
    add_index :passions, :parent_id
  end
end

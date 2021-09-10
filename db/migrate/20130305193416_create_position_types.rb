class CreatePositionTypes < ActiveRecord::Migration
  def change
    create_table :position_types do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    
    add_index :position_types, :parent_id
  end
end

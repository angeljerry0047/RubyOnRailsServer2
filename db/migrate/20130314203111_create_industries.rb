class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :title
      t.integer :naics_code
      t.integer :parent_id

      t.timestamps
    end
    
    add_index :industries, :parent_id
  end
end

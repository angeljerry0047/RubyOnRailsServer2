class CreateCompetencies < ActiveRecord::Migration
  def change
    create_table :competencies do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    
    add_index :competencies, :parent_id
  end
end

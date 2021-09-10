class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.string :title
      t.boolean :internal
      t.integer :organization_id
      t.integer :industry_id
      t.integer :start_year
      t.integer :start_month
      t.integer :end_year
      t.integer :end_month

      t.timestamps
    end
    
    add_index :opportunities, :organization_id
    add_index :opportunities, [:start_year, :start_month]
    add_index :opportunities, [:end_year, :end_month]
    add_index :opportunities, :industry_id
  end
end

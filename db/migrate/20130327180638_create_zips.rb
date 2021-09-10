class CreateZips < ActiveRecord::Migration
  def change
    create_table :zips do |t|
      t.integer :code
      t.column :lonlat, 'point', :geographic => true, :null => false

      t.timestamps
    end
  end
end

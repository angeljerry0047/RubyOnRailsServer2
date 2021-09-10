class AddLonlatAndLocationDataToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :city, :string
    add_column :opportunities, :state, :string
    add_column :opportunities, :lonlat, :point, :geographic => true
    
    change_table :opportunities do |t|
      t.index :lonlat, :spatial => true
    end
  end
end

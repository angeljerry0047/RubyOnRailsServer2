class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :city
      t.string :state

      t.timestamps
    end
    
    add_index :facilities, :state
    
    Facility.create!(:name => 'Center for Non-Profits', :city => 'Rogers', :state => 'AR')
    Facility.create!(:name => 'Jones Center for Families', :city => 'Springdale', :state => 'AR')
  end
end
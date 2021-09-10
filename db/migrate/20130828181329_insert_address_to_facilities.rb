class InsertAddressToFacilities < ActiveRecord::Migration
  def up
 
    execute "UPDATE facilities
             SET address='The Jones Center, East Emma Avenue, Springdale, AR',
             map_location='(36.186585, -94.11825699999997)' 
             WHERE name='The Jones Center'"
             
    execute "UPDATE facilities
             SET address='Center For Non-Profit, West Walnut Street, Rogers, AR',
             map_location='(36.333698, -94.12917099999999)' 
             WHERE name='Center for Non-Profits'"
  end

  def down
  end
end

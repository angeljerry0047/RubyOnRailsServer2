class TakingOutPassionAreas < ActiveRecord::Migration
  def change
    drop_table :passions
    drop_table :passion_hierarchies
  end
end

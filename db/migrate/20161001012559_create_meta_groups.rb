class CreateMetaGroups < ActiveRecord::Migration
  def change
    create_table :meta_groups do |t|

      t.timestamps
    end
  end
end

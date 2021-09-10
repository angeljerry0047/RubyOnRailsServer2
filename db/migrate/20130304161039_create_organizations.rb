class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :type
      t.string :title

      t.timestamps
    end
  end
end

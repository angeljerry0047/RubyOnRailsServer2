class CreateOrganizationsBestPracticesJoinTable < ActiveRecord::Migration
  def up
  	  create_table :organizations_best_practice_categories, :id => false do |t|
      t.integer :best_practice_category_id
      t.integer :organization_id
    end

    add_index :organizations_best_practice_categories, :best_practice_category_id, :name => 'org_bp_categories'
    add_index :organizations_best_practice_categories, :organization_id
  end
  def down
  	drop_table :organizations_best_practice_categories
  end
end

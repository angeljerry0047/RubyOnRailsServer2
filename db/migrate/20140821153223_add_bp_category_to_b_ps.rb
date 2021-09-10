class AddBpCategoryToBPs < ActiveRecord::Migration
	def change
  	add_column :best_practices, :best_practice_category_id, :integer
  	add_column :best_practices, :organization_id, :integer 	
  end
end

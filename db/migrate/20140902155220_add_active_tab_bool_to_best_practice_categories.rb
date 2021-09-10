class AddActiveTabBoolToBestPracticeCategories < ActiveRecord::Migration
  def change
  	add_column :best_practice_categories, :active_tab, :boolean
  end
end

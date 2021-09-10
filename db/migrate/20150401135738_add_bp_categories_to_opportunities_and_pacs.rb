class AddBpCategoriesToOpportunitiesAndPacs < ActiveRecord::Migration
  def change
    add_column :opportunities, :best_practice_category_id, :integer
    add_column :pacs, :best_practice_category_id, :integer
  end
end

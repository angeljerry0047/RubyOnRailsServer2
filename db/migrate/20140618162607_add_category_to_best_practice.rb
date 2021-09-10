class AddCategoryToBestPractice < ActiveRecord::Migration
  def change
    add_column :best_practices, :category, :string
  end
end

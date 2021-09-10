class DeleteCategoryFromOpportunities < ActiveRecord::Migration
  def up
    remove_column :opportunities, :category
  end
end

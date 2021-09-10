class AddIsPublicToBestPractices < ActiveRecord::Migration
  def change
  	add_column :best_practices, :is_public, :boolean
  end
end

class AddAnonymousToBestPractices < ActiveRecord::Migration
  def change
    add_column :best_practices, :anonymous, :boolean
  end
end

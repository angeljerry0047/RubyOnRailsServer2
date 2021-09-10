class AddPointConfirmationToBestPractice < ActiveRecord::Migration
  def change
    add_column :best_practices, :got_point, :boolean, :default => false
  end
end

class AddInterestIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :interest_ids, :integer
  end
end

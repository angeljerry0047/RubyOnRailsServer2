class CreateJoinTableUserInterests < ActiveRecord::Migration
def change
    create_table :users_interests, :id => false do |t|
      t.integer :user_id
      t.integer :interest_id
    end

    add_index :users_interests, :user_id
    add_index :users_interests, :interest_id
  end
end

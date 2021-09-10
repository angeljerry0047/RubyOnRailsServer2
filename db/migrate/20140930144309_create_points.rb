class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :badge_type_id
      t.integer :year

      t.timestamps
    end
  end
end

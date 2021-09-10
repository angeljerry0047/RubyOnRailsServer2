class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :id
      t.integer :creator_id
      t.integer :user_id
      t.boolean :approval_status
      t.integer :opportunity_category_id
      t.string :con_strength
      t.string :con_engagement
      t.string :con_length
      t.string :con_type

      t.timestamps
    end
  end
end

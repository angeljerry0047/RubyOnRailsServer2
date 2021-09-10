class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :opportunity_id
      t.integer :creator_id
      t.text :body

      t.timestamps
    end
  end
end

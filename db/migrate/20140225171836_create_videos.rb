class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.boolean :internal
      t.text :description
      t.text :embed_code
      t.integer :competency_ids
      t.integer :category
      t.string :learning_objectives
      t.integer :opportunity_category_id

      t.timestamps
    end
  end
end

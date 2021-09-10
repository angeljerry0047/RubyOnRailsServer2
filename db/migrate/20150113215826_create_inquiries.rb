class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :organization_id
      t.string :category
      t.integer :best_practice_category_id
      t.string :documents
      t.boolean :is_public, :default => false
      t.boolean :got_point, :default => false

      t.timestamps
    end
  end
end

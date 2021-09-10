class CreateFastContents < ActiveRecord::Migration
  def change
    create_table :fast_contents do |t|
      t.string :topic
      t.text :description
      t.text :ext_link
      t.text :emb_link
      t.string :author
      t.integer :user_id
      t.integer :organization_id
      t.integer :category_id
      t.string  :documents
      t.string  :audio
      t.string  :images

      t.timestamps
    end
  end
end

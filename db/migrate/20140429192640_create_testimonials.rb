class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.integer :opportunity_id
      t.integer :creator_id
      t.boolean :approved
      t.text :body

      t.timestamps
    end
  end
end

class CreateBestPracticeCategories < ActiveRecord::Migration
  def change
    create_table :best_practice_categories do |t|
      t.string :title
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end

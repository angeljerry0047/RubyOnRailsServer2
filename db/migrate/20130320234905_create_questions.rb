class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :group
      t.text :text

      t.timestamps
    end
  end
end

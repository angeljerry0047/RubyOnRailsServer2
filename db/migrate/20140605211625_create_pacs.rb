class CreatePacs < ActiveRecord::Migration
  def change
    create_table :pacs do |t|
      t.boolean :complete

      t.timestamps
    end
  end
end

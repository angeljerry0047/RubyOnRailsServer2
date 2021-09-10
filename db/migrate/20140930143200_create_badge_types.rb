class CreateBadgeTypes < ActiveRecord::Migration
  def change
    create_table :badge_types do |t|
      t.string :name
      t.string :image_url
      t.string :certificate_url

      t.timestamps
    end
  end
end

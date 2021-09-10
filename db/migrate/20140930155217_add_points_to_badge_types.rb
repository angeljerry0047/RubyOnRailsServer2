class AddPointsToBadgeTypes < ActiveRecord::Migration
  def change
    add_column :badge_types, :points, :integer
  end
end

class AddPointsRequiredToBadgeType < ActiveRecord::Migration
  def change
    add_column :badge_types, :points_req, :integer
  end
end

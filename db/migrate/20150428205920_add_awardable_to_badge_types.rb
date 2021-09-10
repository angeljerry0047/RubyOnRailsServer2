class AddAwardableToBadgeTypes < ActiveRecord::Migration
  def change
    add_column :badge_types, :awardable, :boolean
  end
end

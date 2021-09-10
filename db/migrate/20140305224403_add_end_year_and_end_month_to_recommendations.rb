class AddEndYearAndEndMonthToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :end_year, :integer
    add_column :recommendations, :end_month, :integer
  end
end

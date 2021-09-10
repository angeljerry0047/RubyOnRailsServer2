class AddColumnToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :limit, :integer, :default => 0
  end
end

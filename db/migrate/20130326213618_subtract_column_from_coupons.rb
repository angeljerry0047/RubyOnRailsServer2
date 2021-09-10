class SubtractColumnFromCoupons < ActiveRecord::Migration
  def change
    remove_column :coupons, :used
  end
end

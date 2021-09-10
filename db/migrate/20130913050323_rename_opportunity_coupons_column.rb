class RenameOpportunityCouponsColumn < ActiveRecord::Migration
  def change
    rename_column :opportunity_coupons, :valid, :iscurrent
  end
end

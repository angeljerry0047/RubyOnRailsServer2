class AddColumnToCouponUses < ActiveRecord::Migration
  def change
    add_column :coupon_uses, :assessment_report_id, :integer
  end
end

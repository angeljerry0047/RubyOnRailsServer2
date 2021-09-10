class RenameOpportunityApplicationColumns < ActiveRecord::Migration
  def change
    change_column_default :opportunity_applications, :opportunity_scholarship_id, 1
    rename_column :opportunity_applications, :opportunity_scholarship_id, :opportunity_applications_type_id
    rename_column :opportunity_applications, :opportunity_coupon_id, :foreign_key
  end
end

class AddApprovalStatusBooleanToPacs < ActiveRecord::Migration
  def change
    add_column :pacs, :approval_status, :boolean, :default => false
  end
end

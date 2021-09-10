class AddApprovalCodeToPac < ActiveRecord::Migration
  def change
   	add_column :pacs, :approval_code, :string
  end
end

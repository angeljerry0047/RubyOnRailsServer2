class AddStatusToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :approval_status, :boolean, :default => 'false'
    add_column :opportunities, :approval_code, :string
  end
end

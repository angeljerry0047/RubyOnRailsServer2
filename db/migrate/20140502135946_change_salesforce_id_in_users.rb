class ChangeSalesforceIdInUsers < ActiveRecord::Migration
  def up
  	rename_column :users, :salesforce_id, :old_salesforce_id
  end

  def down
 	rename_column :users, :old_salesforce_id, :salesforce_id
  end
end

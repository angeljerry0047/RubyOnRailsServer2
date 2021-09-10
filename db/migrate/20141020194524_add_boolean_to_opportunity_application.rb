class AddBooleanToOpportunityApplication < ActiveRecord::Migration
  def change
    add_column :opportunity_applications, :complete_plan, :boolean, :default => false
  end
end

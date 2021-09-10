class AddWebConfInfoToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :online_info, :text
  end
end

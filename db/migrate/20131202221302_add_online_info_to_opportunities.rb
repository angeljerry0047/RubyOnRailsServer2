class AddOnlineInfoToOpportunities < ActiveRecord::Migration
  def change
  	add_column :opportunities, :webcast_id, :string
  	add_column :opportunities, :webcast_facilitator_id, :string
  end
end

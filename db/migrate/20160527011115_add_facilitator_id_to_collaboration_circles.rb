class AddFacilitatorIdToCollaborationCircles < ActiveRecord::Migration
  def change
    add_column :collaboration_circles, :facilitator_id, :integer
  end
end

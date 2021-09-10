class AddOrganizationIdToMentorshipCircle < ActiveRecord::Migration
  def change
    add_column :mentorship_circles, :organization_id, :integer
  end
end

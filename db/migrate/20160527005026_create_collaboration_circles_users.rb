class CreateCollaborationCirclesUsers < ActiveRecord::Migration
  def change
    create_table :collaboration_circles_users, id: false do |t|
      t.belongs_to :collaboration_circle, index: true
      t.belongs_to :user, index: true
    end
  end
end

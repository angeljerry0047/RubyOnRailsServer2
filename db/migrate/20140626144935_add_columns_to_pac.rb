class AddColumnsToPac < ActiveRecord::Migration
  def change
  	add_column :pacs, :description, :text
  	add_column :pacs, :webcast_id, :string
  	add_column :pacs, :webcast_facilitator_id, :string
  	add_column :pacs, :opportunity_type_id, :integer
  	add_column :pacs, :category, :string
    add_column :pacs, :learning_objectives, :text
    add_column :pacs, :start_date, :datetime
    add_column :pacs, :deadline_date, :datetime
    add_column :pacs, :start_time, :string
    add_column :pacs, :end_time, :string
    add_column :pacs, :max_students, :integer
    add_column :pacs, :min_students, :integer
    add_column :pacs, :facility_id, :integer
    add_column :pacs, :owner_id, :integer
    add_column :pacs, :title, :string
    add_column :pacs, :city, :string
    add_column :pacs, :state, :string
    add_column :pacs, :organization_id, :integer
  end
end

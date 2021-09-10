class AddColumnsToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :address, :string
    add_column :facilities, :map_location, :string
    add_column :facilities, :approval_name, :string
    add_column :facilities, :approval_mail, :string
  end
end

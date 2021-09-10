class AddInternalDescriptionToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :int_description, :text
  end
end

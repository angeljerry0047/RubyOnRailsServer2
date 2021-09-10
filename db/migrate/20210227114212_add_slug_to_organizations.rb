class AddSlugToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :slug, :string
    add_index :organizations, :slug
  end
end

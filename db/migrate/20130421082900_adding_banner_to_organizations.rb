class AddingBannerToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :banner, :string
  end
end

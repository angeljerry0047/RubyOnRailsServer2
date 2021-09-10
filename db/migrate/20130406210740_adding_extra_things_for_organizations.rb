class AddingExtraThingsForOrganizations < ActiveRecord::Migration
  def change
    
    
    add_column :organizations, :description, :text
    add_column :organizations, :company_size_min, :integer
    add_column :organizations, :company_size_max, :integer
    add_column :organizations, :company_type, :string
    add_column :organizations, :website, :string
    add_column :organizations, :industry_id, :integer
    add_column :organizations, :operating_status, :string
    add_column :organizations, :year_founded, :integer
    add_column :organizations, :address1, :string
    add_column :organizations, :address2, :string
    add_column :organizations, :city, :string
    add_column :organizations, :state, :string
    add_column :organizations, :zipcode, :integer
  end
end

class AddDepartmentToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :department, :string
  end
end

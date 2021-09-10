class AddColumnToIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :naics_code_top, :integer
  end
end

class AddPriceToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :price, :decimal
  end
end

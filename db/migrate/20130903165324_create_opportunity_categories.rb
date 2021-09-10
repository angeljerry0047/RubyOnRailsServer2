class CreateOpportunityCategories < ActiveRecord::Migration
  def change
      create_table :opportunity_categories do |t|      
       t.string :name
       t.decimal :price 
       t.timestamps
       end
       
  end   
end

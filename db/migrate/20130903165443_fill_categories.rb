class FillCategories < ActiveRecord::Migration

  def change
    OpportunityCategory.create!(:name => 'Leadership Development Training', :price => 10 )
    OpportunityCategory.create!(:name => 'Technical Skills Training', :price => 10 )
    OpportunityCategory.create!(:name => 'Ideation Session', :price => 0 )
    OpportunityCategory.create!(:name => 'Mentor/Sponsor', :price => 0 )
    OpportunityCategory.create!(:name => 'Board/Committee Service', :price => 0 )   
  end 

end

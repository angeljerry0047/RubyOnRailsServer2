# == Schema Information
#
# Table name: opportunity_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  price         :decimal(, )
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recommendable :boolean
#

# FIXME (cmhobbs+tyreldenison) use rails here.
class OpportunityCategory < ActiveRecord::Base
  
  def self.permitted(params)
    opportunity_category_whitelist = [:name, :price]
    params.permit(opportunity_category: opportunity_category_whitelist)
  end
  
  scope :recommendable, -> { where(:recommendable => true) }
  scope :alphabetical,  -> { order(:name) }
  
  has_many :opportunities
  has_many :recommendations
  has_many :delivery_competencies
  has_many :competencies, :through => :delivery_competencies
  
  def mentor
    [4, 15, 17].include? self.id
  end
  
  def coach
    [8, 14, 10, 16, 1, 18].include? self.id
  end
  
  def advisor
    [4, 15, 17, 8, 14, 10, 16, 1, 18].include? self.id
  end
  
  def training
    [2, 9, 7, 20].include? self.id
  end
  
  def intern
    [6, 19].include? self.id
  end
  
  def volunteer
    [5, 21].include? self.id
  end
  
end

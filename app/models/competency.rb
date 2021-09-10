# == Schema Information
#
# Table name: competencies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class Competency < ActiveRecord::Base
  def self.permitted(params)
    competency_whitelist = [:name, :parent_id]

    params.permit(competency: competency_whitelist)
  end
  acts_as_tree

  has_many :users, :through => :competencies_users
  has_many :competencies_users
  
  has_many :delivery_competencies
  has_many :opportunity_categories, :through => :delivery_competencies

  validates_uniqueness_of :name
end

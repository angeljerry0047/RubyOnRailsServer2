# == Schema Information
#
# Table name: form_of_learnings
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  recommendable :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FormOfLearning < ActiveRecord::Base
  def self.permitted(params)
    form_of_learning_whitelist = [:name]
    params.permit(form_of_learning: form_of_learning_whitelist)
  end

  scope :recommendable, -> { where(:recommendable => true) }
  scope :alphabetical,  -> { order(:name) }

  has_many :opportunities
  has_many :inquries
  has_many :best_practices
  has_many :recommendations
  has_many :delivery_competencies
  has_many :competencies, :through => :delivery_competencies
  
end

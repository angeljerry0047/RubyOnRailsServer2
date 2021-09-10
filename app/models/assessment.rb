# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :decimal(, )
#

class Assessment < ActiveRecord::Base
  def self.permitted(params)
    assessment_whitelist = [ :description, :title, :price ]
    params.permit(assessment: assessment_whitelist)
  end
  
  has_many :question_groups

  def questions
    question_groups.map(&:questions).flatten
  end

end

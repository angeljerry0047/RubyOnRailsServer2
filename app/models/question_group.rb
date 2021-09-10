# == Schema Information
#
# Table name: question_groups
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assessment_id :integer
#

class QuestionGroup < ActiveRecord::Base
  def self.permitted(params)
    question_group_whitelist = [:description, :name]
    params.permit(question_group: question_group_whitelist)
  end
  
  has_many :questions
  has_and_belongs_to_many :competencies
  has_many :competencies_question_groups
  
  belongs_to :assessment
  
  def competencies_by_bucket(bucket_name)
    Competency.where(:id => competencies_question_groups.where(:rating_bucket => bucket_name).map(&:competency_id))
  end
end

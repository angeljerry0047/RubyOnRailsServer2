# == Schema Information
#
# Table name: competencies_question_groups
#
#  competency_id     :integer
#  question_group_id :integer
#  rating_bucket     :string(255)
#

class CompetenciesQuestionGroup < ActiveRecord::Base
  def self.permitted(params)
    competencies_question_group_whitelist = [:question_group_id, :competency_id, :rating_bucket]
    params.permit(competencies_question_group: competencies_question_group_whitelist)
  end
  
  belongs_to :competency
  belongs_to :question_group
end

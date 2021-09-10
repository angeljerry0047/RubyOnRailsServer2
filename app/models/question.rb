# == Schema Information
#
# Table name: questions
#
#  id                :integer          not null, primary key
#  text              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  assessment_id     :integer
#  question_group_id :integer
#

class Question < ActiveRecord::Base
  def self.permitted(params)
    question_whitelist = [:group, :text]
    params.permit(question: question_whitelist)
  end
  
  belongs_to :question_group
  
  has_many :user_answers
  has_many :users, :through => :user_answers
end

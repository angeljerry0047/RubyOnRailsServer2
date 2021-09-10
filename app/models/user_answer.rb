# == Schema Information
#
# Table name: user_answers
#
#  id                   :integer          not null, primary key
#  question_id          :integer
#  likert_response      :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assessment_report_id :integer
#

class UserAnswer < ActiveRecord::Base
  def self.permitted(params)
    user_answer_params = %i[likert_response question_id user_id]

    params.permit(user_answer: user_answer_params)
  end

  belongs_to :assessment_report
  belongs_to :question
  belongs_to :user
  delegate   :assessment, to: :assessment_report

  # NOTE: (cmhobbs+tyreldenison) track down 'likert'
  # validates_numericality_of :likert_response, less_than: 5, greater_than: -1
  validates_inclusion_of :likert_response, in: 0..4
end

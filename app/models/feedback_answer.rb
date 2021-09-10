# == Schema Information
#
# Table name: feedback_answers
#
#  id         :integer          not null, primary key
#  answer     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FeedbackAnswer < ActiveRecord::Base
  def self.permitted(params)
    feedback_answer_whitelist = [:answer]
    params.permit(feedback_answer: feedback_answer_whitelist)
  end

  has_many :feedbacks
end

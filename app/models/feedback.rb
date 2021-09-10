# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  opportunity_id :integer
#  creator_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  q1             :integer
#  q2             :integer
#  q3             :integer
#  q4             :integer
#  q5             :integer
#

class Feedback < ActiveRecord::Base
  def self.permitted(params)
    feedback_whitelist = [:q1, :q2, :q3, :q4, :q5, :creator_id, :opportunity_id]
    params.permit(feedback: feedback_whitelist)
  end

  belongs_to :opportunity
  belongs_to :creator, :class_name => "User"
  has_many :feedback_answers, :source => :q1

  def answer(question)
    FeedbackAnswer.find(question).answer
  end
end

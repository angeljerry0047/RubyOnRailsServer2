# == Schema Information
#
# Table name: assessment_reports
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  state         :string(255)
#  assessment_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# NOTE (cmhobbs+tyreldenison) this is handled in #capacity_from and needs
#      to be refactored.  this replaces an uncaught throw
class ScoreBoundaryError < StandardError; end

class AssessmentReport < ActiveRecord::Base
  def self.permitted(params)
    assessment_report_whitelist = [:assessment_id, :user_id, { user_answers: [] }]

    params.permit(assessment_report: assessment_report_whitelist)
  end

  belongs_to :user
  belongs_to :assessment

  # Important to go through Assessment not User.
  # This is the canonical representation of questions vs the questions the user answered
  has_many :question_groups, :through => :assessment
  has_many :user_answers, -> { uniq }

  def self.buckets
    [
      [(0...1.4),   'Positional'],
      [(1.4...3.5), 'Functional'],
      [(3.5..4),    'Organizational Stakeholder']
    ]
  end

  def competencies_needed
    lowest_scoring = {}

    question_groups.each do |group|
      score = score_for(group)
      lowest_scoring[score] = [] unless lowest_scoring[score]
      lowest_scoring[score] << group
    end

    lowest_scoring[lowest_scoring.keys.min].map(&:competencies).flatten
  end

  # FIXME (cmhobbs+tyreldenison) make this more intention revealing
  def competencies_needed_for(group)
    group ? group.competencies_by_bucket(group_capacity(group).downcase) : []
  end

  def answers
    user_answers
  end

  def response_for(question)
    user_answer = user_answers.select{|ua| ua.question_id == question.id}.first
    user_answer ? user_answer.likert_response : :nothing_there
  end

  def answer!(question, answer_hash)
    if answers.exists?(:question_id => question.id)
      ans = answers.where(question_id: question.id).first
      ans.likert_response = answer_hash.fetch(:with)
      ans.save!
    else
      user_answers << UserAnswer.create(
        :user_id => user.id,
        :question_id => question.id,
        :likert_response => answer_hash.fetch(:with)
      )
    end
  end

  def answers_for(group)
    if user_answers.empty?
      []
    else
      user_answers.joins(:question => :question_group).where('question_groups.id' => group.id)
    end
  end

  def score_for(group)
    calculate_score(answers_for(group))
  end

  def score
    calculate_score(user_answers)
  end

  def gross_score
    user_answers.map(&:likert_response).inject(&:+) || 0
  end

  def gross_score_for(group)
    answers_for(group).map(&:likert_response).inject(&:+) || 0
  end

  def gross_score_for_group(name)
    answers_for(question_groups.where(:name => name).first).map(&:likert_response).inject(&:+) || 0
  end

  def complete?
    Question.where(:question_group_id => assessment.question_group_ids).count == user_answers.count
  end

  def not_complete?
    !complete?
  end

  def blurb_about_group(group_name)
    yml = YAML::load_file(Rails.root.join("./config/copy_for_assessment.yml"))
    yml.fetch(group_name.to_s, {}).fetch(group_capacity_from_name(group_name).to_s.downcase, "")
  end

  # NOTE (cmhobbs+tyreldenison) potential source of NoMethodError conditions
  def capacity_from(score)
    self.class.buckets.each do |bucket|
      if bucket.first.include?(score)
        return bucket.last
      end
    end
    raise ScoreBoundaryError
  end

  def overall_capacity
    capacity_from(self.score)
  end

  def group_capacity(group)
    capacity_from(score_for(group))
  end

  def group_capacity_from_name(group_name)
    group_capacity(question_groups.where(:name => group_name).first)
  end

  private

  def calculate_score(scope)
    return 0 if not_complete? || user_answers.count == 0

    denom = 0
    numerator = 0
    scope.each do |ans|
      numerator += ans.likert_response
      denom += 1
    end

    Rational(numerator, denom).to_f.round(2)
  end
end

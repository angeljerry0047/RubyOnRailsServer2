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

require 'spec_helper'

describe AssessmentReport do
  let(:user) { FactoryBot.create(:user) }
  let(:asshat_group) do
    lg = FactoryBot.create(:question_group, :name => 'asshats')
    lg.questions = FactoryBot.create_list(:question, 1)
    lg.save!
    lg
  end
  
  let(:leadership_group) do
    lg = FactoryBot.create(:question_group, :name => 'leadership')
    lg.questions = FactoryBot.create_list(:question, 2)
    lg.save!
    lg
  end
  
  # let (:asshat) { FactoryBot.create(:question, :group => "asshats")}
  let(:assessment) { 
    ass = FactoryBot.create(:assessment)
    ass.question_groups = [asshat_group, leadership_group]
    ass
  }
  
  let(:assessment_report) { FactoryBot.create(:assessment_report, :user => user, :assessment => assessment) }
  
  context 'average score calculated' do
    it 'calculates a score based on the groups' do
      scores = []
      assessment.questions.each do |question|
        scores << rand(5)
        assessment_report.answer!(question, :with => scores.last)
      end

      average = Rational(scores.inject(&:+), scores.length).to_f.round(2)

      assessment_report.score.should == average
    end
  end
  
  context 'needed competencies' do
    it 'returns competencies needed as the competencies in the bottom scoring question_group' do
      assessment.questions.each do |question|
        assessment_report.answer!(question, :with => (question.question_group.name == 'asshats') ? 4 : 1)
      end
      
      asshats = assessment.question_groups.where(:name => 'asshats').first
      leadership = assessment.question_groups.where(:name => 'leadership').first
      
      lead_competencies = FactoryBot.create_list(:competency, 2)
      asshats_competencies = FactoryBot.create_list(:competency, 2)
      
      asshats.competencies = asshats_competencies
      leadership.competencies = lead_competencies
      leadership.save!
      asshats.save!
      
      assessment_report.competencies_needed.sort.should == lead_competencies.sort
      
      # Asshats get a 4 and leadership a 1
      # Leadership is the lowest question_group
    end
  end
  
  context 'answer!' do
    let(:question) { assessment.questions.last }
    it 'overrides the old answer if it exists' do
      assessment_report
      UserAnswer.count.should == 0
      assessment_report.answer!(question, :with => 1)
      assessment_report.answer!(question, :with => 3)
      UserAnswer.count.should == 1
      assessment_report.answers.last.likert_response.should == 3
    end
    
    it 'creates a new answer if it doesnt exist' do
      UserAnswer.count.should == 0
      assessment_report.answer!(question, :with => 1)
      assessment_report.answers.last.question_id.should == question.id
    end
  end

  it 'determines complete?' do
    assessment_report.should_not be_complete
  end
  
  
  context 'responses' do
    it 'returns :nothing_there if there is no response' do
      assessment_report.response_for(FactoryBot.create(:question)).should == :nothing_there
    end
    
    it 'returns the likert_response if there is a response' do
      
      response = rand(5)
      assessment_report.answer!(assessment.questions.last, :with => response)
      assessment_report.response_for(assessment.questions.last).should == response
    end
  end
  
  it 'should never have a score outside 0 - 4' do
    lambda { assessment_report.capacity_from(4.01) }.should raise_error
    lambda { assessment_report.capacity_from(-0.01) }.should raise_error
  end
  
  it 'calculates a average_group_score' do
    scores = []
    
    
    
    assessment.question_groups.each do |question_group|
      question_group.questions.each do |question|
        sc = rand(5)
        if question_group.name == 'leadership'
          scores << sc
        end
        assessment_report.answer!(question, :with => sc)
      end
    end
    
    score = Rational(scores.inject(&:+), scores.length).to_f.round(2)
    
    assessment_report.score_for(leadership_group).should == score
  end
  
end

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

require 'spec_helper'

describe UserAnswer do
  
  context 'must have likert responses between 0 and 4' do
    [-1, 5].each do |bad|
      it "does not allow #{bad} as a likert response" do
        ua = FactoryBot.build(:user_answer, :likert_response => bad)
        ua.should_not be_valid
      end
    end
    
    [0, 4].each do |good|
      it "does allow #{good} as a likert response" do
        ua = FactoryBot.build(:user_answer, :likert_response => good)
        ua.should be_valid
      end
    end
  end
end

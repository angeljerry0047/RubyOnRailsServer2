class AddJoinTableForAssessmentsAndAnswers < ActiveRecord::Migration
  def change
    # Oops named this wrong...
    create_table :assessments_questions, :id => false do |t|
      t.integer :assessment_id
      t.integer :question_id
    end
  end
end

class ChangingHabtmToHasManyQuestionsAssessments < ActiveRecord::Migration
  def change
    drop_table :assessments_questions
    
    add_column :questions, :assessment_id, :integer
    add_index :questions, :assessment_id
  end
end

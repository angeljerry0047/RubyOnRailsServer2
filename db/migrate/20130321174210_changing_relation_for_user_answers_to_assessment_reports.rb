class ChangingRelationForUserAnswersToAssessmentReports < ActiveRecord::Migration
  def change
    add_column :user_answers, :assessment_report_id, :integer
    add_index :user_answers, :assessment_report_id
  end
end

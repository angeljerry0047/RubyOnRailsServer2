class CreateAssessmentReports < ActiveRecord::Migration
  def change
    create_table :assessment_reports do |t|
      t.integer :user_id
      t.string :state
      t.integer :assessment_id

      t.timestamps
    end
  end
end
